#!/bin/bash

clear

init() {
	LOG_DELIMETR="----------"
	IS_ERR=0

	PATH_TO_SO="extensions/bin/linux"
	PATH_TO_INI="extensions"
	INI_FILE="virgil_crypto.ini"

	LIST_EXT="vsce_phe_php vscf_foundation_php vscp_pythia_php vscr_ratchet_php"

	printf "Сrypto extensions installation...\n%s\n" $LOG_DELIMETR
}

get_err() {
	IS_ERR=1
	case "$1" in
		php-v)
			ERR_MSG="Invalid PHP version: $2"
			;;
		os)
			ERR_MSG="Invalid OS: $2"
			;;
		ext-dir)
			ERR_MSG="Invalid extensions directory: $2"
			;;
		ini-dir)
			ERR_MSG="Invalid additional .ini files directory: $2"
			;;
		cp-ext|cp-ini)
			ERR_MSG="Cannot copy $2 to the $3"
			;;
		*)
			ERR_MSG="Internal error: $1"
			;;
	esac

	printf "[FAIL]\nError status: %s\n" "$ERR_MSG"
	exit 0
}

get_warn() {
	case "$1" in
		restart)
			ERR_MSG="Restart your webserver manualy!"
			;;
	esac

	printf "%s\n[WARNING] %s\n" $LOG_DELIMETR "$ERR_MSG"
}

get_success() {
	printf "[OK]\n"
}

get_php_v() {

	printf "Checking PHP version... "

	PHP_VERSION=$(php -v)
	set -- $PHP_VERSION
	PHP_VERSION_STRING="$2"
	PHP_VERSION_MAJOR=`echo $PHP_VERSION_STRING | cut -f 1 -d'.'`
	PHP_VERSION_MINOR=`echo $PHP_VERSION_STRING | cut -f 2 -d'.'`
	PHP_VERSION_SHORT=$PHP_VERSION_MAJOR.$PHP_VERSION_MINOR

	if [ $PHP_VERSION_SHORT != "7.2" ] && [ $PHP_VERSION_SHORT != "7.3" ]; then
		get_err "php-v" "$PHP_VERSION_SHORT"
	else
		get_success
	fi
}

get_os() {
	printf "Checking OS... "
	OS=$(uname)

	case $OS in
	     Linux)
	          OS_="linux-x86_64"
	          ;;
	     Darwin)
	          OS_="darwin-18.5-x86_64"
	          ;;
	     *)
	          OS_=""
	          ;;
	esac

	if [ -z "$OS_" ]; then
		get_err "os" "$OS"
	else
		get_success
	fi
}

get_ext_dir() {
	printf "Checking PHP extensions directory... "

	EXTENSION_DIR=$(php-config --extension-dir)

	if [ -z "EXTENSION_DIR" ]; then
		get_err "ext-dir" "(null)"
	else
		get_success
	fi
}

get_ini_dir() {
	printf "Checking additional .ini files directory... "

	PHP_INI_DIR_STRING=$(php -i | grep "Scan this dir for additional .ini files")
	PHP_INI_DIR_=`echo $PHP_INI_DIR_STRING | cut -f 2 -d'>'`
	PHP_INI_DIR_="$(echo "${PHP_INI_DIR_}" | tr -d '[:space:]')"

	PHP_INI_DIR=$PHP_INI_DIR_

	# Try to convert cli->fpm
	PHP_INI_DIR_CONVERT_TO_FPM=${PHP_INI_DIR_//cli/fpm}

	if [ -d "$PHP_INI_DIR_CONVERT_TO_FPM" ]; then
  		PHP_INI_DIR=$PHP_INI_DIR_CONVERT_TO_FPM
	fi

	if [ -z "$PHP_INI_DIR_STRING" ]; then
		get_err "ini-dir" "(null)"
	else
		get_success
	fi
}

get_config() {
	if [ $IS_ERR -eq 0 ]; then
		printf "%s\nSYSTEM CONFIGURATION:\n" $LOG_DELIMETR

		printf "OS: %s\n" "$OS"
		printf "PHP version (short): %s\n" "$PHP_VERSION_SHORT"
		printf "PHP version (full):\n%s\n" "$PHP_VERSION"
		printf "Extensions directory: %s\n" "$EXTENSION_DIR"
		printf "Additional .ini files directory: %s\n" "$PHP_INI_DIR"
		printf "%s\n" $LOG_DELIMETR
	fi
}

cp_ext() {
	for EXT in $LIST_EXT
	do
		printf "Copying $EXT.so to the $EXTENSION_DIR... "
		
		if sudo cp "$PATH_TO_SO/$EXT.so" "$EXTENSION_DIR/$EXT.so"; then
			get_success
		else
			get_err "cp-ext" "$EXT.so" "$EXTENSION_DIR"
		fi
	done
}

cp_ini() {
    printf "Copying $INI_FILE to the $PHP_INI_DIR... "

	if sudo cp "$PATH_TO_INI/$INI_FILE" "$PHP_INI_DIR/$INI_FILE"; then
		get_success
	else
		get_err "cp-ini" "$INI_FILE" "$PHP_INI_DIR"
	fi
}

restart() {
	IS_RESTARTED=0

	if service --status-all | grep -Fq 'apache2'; then
		IS_RESTARTED=1   
	  	sudo service apache2 restart
	else service --status-all | grep -Fq 'php7.2-fpm'
		IS_RESTARTED=1
		sudo service php7.2-fpm restart
	fi

	if [ $IS_RESTARTED -eq 0 ]; then
		get_warn "restart"
	fi
}

finish() {
	if [ $IS_ERR -eq 0 ]; then
		printf "%s\n[DONE]\n" $LOG_DELIMETR
		exit 1
	fi
}

warning() {
	printf "%s\nPlease try installing the extension manually in accordance with this instruction:\n" $LOG_DELIMETR
	echo -e '\e]8;;https://github.com/VirgilSecurity/virgil-purekit-php#additional-information\ahttps://github.com/VirgilSecurity/virgil-purekit-php#additional-information\e]8;;\a'
}

init
get_php_v
get_os
get_ext_dir
get_ini_dir
get_config
cp_ext
cp_ini
restart
warning
finish
