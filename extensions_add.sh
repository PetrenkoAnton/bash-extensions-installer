#!/bin/bash

clear

ERR_LEVEL=0
ERR_MSG_NO_INPUT_DATA="No input data"
PROJECT=0
LIST_EXT=""

check_input() {
    printf "Checking input... "

    if [[ "$1" =~ ^(phe|foundation)$ ]]; then
        case "$1" in
            "foundation")
                PROJECT=1
                LIST_EXT="vscf_foundation_php"
                ;;
            "phe")
                PROJECT=2
                LIST_EXT="vscf_foundation_php vsce_phe_php"
                ;;
        esac
        get_success
    else

        if [ -z "$1" ]; then
            get_err "input_null"
        else
            get_err "input_invalid" "$1"
        fi
    fi
}

init() {
	LOG_DELIMETR="----------"
	ERR_LEVEL=0

	PATH_TO_SO="extensions/bin/linux"
	PATH_TO_INI="extensions"
}

get_err() {
	ERR_LEVEL=2
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
        input_null)
            ERR_MSG="Project not specified"
            ;;
		input_invalid)
			ERR_MSG="Invalid project: $2"
			;;
		*)
			ERR_MSG="Internal error: $1"
			;;
	esac

	printf "[FAIL]\nError status: %s\n" "$ERR_MSG"
	exit 0
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
	if [ $ERR_LEVEL -eq 0 ]; then
		printf "%s\nSYSTEM CONFIGURATION:\n" $LOG_DELIMETR

		printf "OS (short): %s\n" "$OS"
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
    for EXT in $LIST_EXT
    do
        printf "Copying $EXT.ini file to the $PHP_INI_DIR... "
        
        if sudo cp "$PATH_TO_INI/$EXT.ini" "$PHP_INI_DIR/$EXT.ini"; then
            get_success
        else
            get_err "cp-ini" "$EXT.ini" "$PHP_INI_DIR"
        fi
    done
}

finish() {

	printf "%s\nSTATUS: " "$LOG_DELIMETR"

	case $ERR_LEVEL in
	     0)
	          printf "Success!\n" 
	          ;;
	     1)
	          printf "$WARN_MSG\n"
	          ;;
	     *)
	          get_err "$ERR_LEVEL"
	esac

	exit 1
}

warning() {
	printf "%s\nPlease try installing the extension manually in accordance with this instruction:\n" $LOG_DELIMETR
	echo -e '\e]8;;https://github.com/VirgilSecurity/virgil-purekit-php#additional-information\ahttps://github.com/VirgilSecurity/virgil-purekit-php#additional-information\e]8;;\a'
}

printf "Сrypto extensions installation...\n%s\n" $LOG_DELIMETR

check_input
init
get_php_v
get_os
get_ext_dir
get_ini_dir
get_config
cp_ext
cp_ini

if [ $ERR_LEVEL -eq 2 ]; then
	warning
fi

finish
