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
		*)
			ERR_MSG="Internal error"
			;;
	esac

	printf "[error]\n%s\nError status: %s\n" $LOG_DELIMETR "$ERR_MSG"
}

get_success() {
	printf "[success]\n"
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

get_res() {
	if [ $IS_ERR -eq 0 ]
	then
		printf "%s\nSystem configuration:\n" $LOG_DELIMETR
		printf "PHP version (short): %s\n" $PHP_VERSION_SHORT
		printf "PHP version (full):\n%s\n" "$PHP_VERSION"
	fi
}

init
get_php_v
get_res
