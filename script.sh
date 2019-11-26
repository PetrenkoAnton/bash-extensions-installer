#!/bin/bash

clear

init() {
	LOG_DELIMETR="----------"
	IS_ERR=0

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
		*)
			ERR_MSG="Internal error"
			;;
	esac

	printf "[error]\nError status: %s\n" "$ERR_MSG"
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

	if [ $PHP_VERSION_SHORT != "7.2" ]
	then
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
	     *)
	          OS_=""
	          ;;
	esac

	if [ -z "$OS_" ]
	then
		get_err "os" "$OS"
	else
		get_success
	fi
}

get_ext_dir() {
	printf "Checking PHP extensions directory... "

	EXTENSION_DIR=$(php-config --extension-dir)

	if [ -z "EXTENSION_DIR" ]
	then
		get_err "ext-dir" "(null)"
	else
		get_success
	fi
}

get_res() {
	if [ $IS_ERR -eq 0 ]
	then
		printf "%s\nSYSTEM CONFIGURATION:\n" $LOG_DELIMETR

		printf "OS: %s\n" "$OS"
		printf "PHP version (short): %s\n" "$PHP_VERSION_SHORT"
		printf "PHP version (full):\n%s\n" "$PHP_VERSION"
		printf "Extensions directory: %s\n" $EXTENSION_DIR
	fi
}

init
get_php_v
get_os
get_ext_dir
get_res
