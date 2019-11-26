#!/usr/bin/env bash

clear
### MAIN CONFIG -->
LATEST_VERSION="2.6.3"
PHP="php"
EXTENSION_NAME_VIRGIL_CRYPTO_PHP="virgil_crypto_php"
EXTENSION_NAME_VSCE_PHE_PHP="vsce_phe_php"
DOWNLOAD_DIR="./for-dev"
### <-- MAIN_CONFIG

### LOG FORMATTER -->
LOG_DELIMETR="-----"
LOG_LOADED="Loaded"
LOG_NOT_LOADED="Not Loaded"
### <-- LOG FORMATTER

### PHP.INI FILE CHECKER -->
PHP_INI_FILE_STRING=$(php -i | grep "Configuration File (php.ini) Path")
PHP_INI_FILE=`echo $PHP_INI_FILE_STRING | cut -f 2 -d'>'`
PHP_INI_FILE="$(echo "${PHP_INI_FILE}" | tr -d '[:space:]')"
### <-- PHP.INI FILE CHECKER

### PHP VERSION CHECHER -->
PHP_VERSION=$(php -v)
set -- $PHP_VERSION
PHP_VERSION_STRING="$2"
PHP_VERSION_MAJOR=`echo $PHP_VERSION_STRING | cut -f 1 -d'.'`
PHP_VERSION_MINOR=`echo $PHP_VERSION_STRING | cut -f 2 -d'.'`
PHP_VERSION_SHORT=$PHP_VERSION_MAJOR.$PHP_VERSION_MINOR
### <-- PHP VERSION CHECKER

### OS CHECHER -->
UNAME=$(uname)
OS_FORMATTED_UNKNOWN=""
case $UNAME in
     Linux)
          OS_FORMATTED="linux-x86_64"
          ;;
     Darwin)
          OS_FORMATTED="darwin-18.5-x86_64"
          ;;
     # Other|Other)
     #      OS_FORMATTED="..."
     #      ;;
     *)
          OS_FORMATTED_UNKNOWN="$UNAME"
          ;;
esac
### <-- OS CHECHER

### EXTENSIONS CHECKER -->
EXTENSION_DIR=$(php-config --extension-dir)
VIRGIL_CRYPTO_PHP=$(php -m | grep "$EXTENSION_NAME_VIRGIL_CRYPTO_PHP")
VSCE_PHE_PHP=$(php -m | grep "$EXTENSION_NAME_VSCE_PHE_PHP")

if [ -z "$VIRGIL_CRYPTO_PHP" ]
then
      STATUS_VIRGIL_CRYPTO_PHP="$LOG_NOT_LOADED"
else
      STATUS_VIRGIL_CRYPTO_PHP="$LOG_LOADED"
fi

if [ -z "$VSCE_PHE_PHP" ]
then
      STATUS_VSCE_PHE_PHP="$LOG_NOT_LOADED"
else
      STATUS_VSCE_PHE_PHP="$LOG_LOADED"
fi
### <-- EXTENSIONS CHECKER

if [ -z "$OS_FORMATTED_UNKNOWN" ]
then
	### FORMAT LINK -->
	LINK_CRYPTO_NAME="virgil-crypto"
	LINK_LANGUAGE=$PHP
	LINK_ARCHIVE_CRYPTO_VERSION=$LATEST_VERSION
	LINK_ARCHIVE_PHP_VERSION=$PHP_VERSION_SHORT
	LINK_ARCIVE_LANGUAGE=$PHP
	LINK_ARCIVE_OS=$OS_FORMATTED
	LINK_ARCHIVE_OUTPUT_FORMAT="tgz"
	LINK_ARCHIVE_FOLDER="virgil-crypto-$LINK_ARCHIVE_CRYPTO_VERSION-$LINK_ARCIVE_LANGUAGE-$LINK_ARCHIVE_PHP_VERSION-$LINK_ARCIVE_OS"
	LINK_ARCHIVE_FORMAT="$LINK_ARCHIVE_FOLDER.$LINK_ARCHIVE_OUTPUT_FORMAT"
	LINK_MAIN_FORMAT="https://cdn.virgilsecurity.com/$LINK_CRYPTO_NAME/$LINK_LANGUAGE/$LINK_ARCHIVE_FORMAT"
	### <-- FORMAT LINK

	### GET EXTENSION FILE --> 
	mkdir -p $DOWNLOAD_DIR
	wget -O $DOWNLOAD_DIR/$LINK_ARCHIVE_FORMAT -c --progress=dot $LINK_MAIN_FORMAT
	tar -xzvf $DOWNLOAD_DIR/$LINK_ARCHIVE_FORMAT -C $DOWNLOAD_DIR

	DOWNLOADED_EXTENSION=$DOWNLOAD_DIR/$EXTENSION_NAME_VIRGIL_CRYPTO_PHP.so

	cp $DOWNLOAD_DIR/$LINK_ARCHIVE_FOLDER/lib/$EXTENSION_NAME_VIRGIL_CRYPTO_PHP.so $DOWNLOADED_EXTENSION
	rm -rf $DOWNLOAD_DIR/$LINK_ARCHIVE_FOLDER
	rm -rf $DOWNLOAD_DIR/$LINK_ARCHIVE_FORMAT
	### <-- GET EXTENSION FILE

	### LINK CHECKER -->
	### <-- LINK CHECKER

	### CHECK AND UPDATE PHP.INI -->
	TEMPLATE=extension=$EXTENSION_NAME_VIRGIL_CRYPTO_PHP
	COMMENTED=";"
	COUNT_COMMENTED=$(grep -c -i -w $COMMENTED$TEMPLATE $PHP_INI_FILE/php.ini)
	COUNT=$(grep -c -i -w $TEMPLATE $PHP_INI_FILE/php.ini)
	if [ $COUNT_COMMENTED -eq $COUNT ] 
	then
	printf "\n%s" $TEMPLATE >> $PHP_INI_FILE/php.ini
	fi
	### <-- CHECK AND UPDATE PHP.INI

	### UPDATE EXTENSION DIR -->
	cp $DOWNLOADED_EXTENSION $EXTENSION_DIR
	### <--UPDATE EXTENSION DIR 

	### PHP7.2-FPM RELOADER -->
	service php7.2-fpm restart
	echo $LOG_DELIMETR
	echo "PHP7.2-FPM reloaded"
	### <-- PHP7.2-FPM RELOADER

	### APACHE RELOADER -->
	# sudo service apache2 reload
	### <-- APACHE RELOADER
else
    printf "%s\n:::Error:::\nPlease contact to support team and show them the output\n" $LOG_DELIMETR
fi

### LOG -->
printf "%s\n:::CONFIGURATION:::\n%s\n" $LOG_DELIMETR $LOG_DELIMETR
printf "URL: \n%s\n%s\n%s\n" "https://cdn.virgilsecurity.com/virgil-crypto/php/virgil-crypto-2.6.3-php-7.2-linux-x86_64.tgz" "$LINK_MAIN_FORMAT" $LOG_DELIMETR
printf "OS: %s\n%s\n" "$UNAME" $LOG_DELIMETR
printf "PHP version (short): %s\n" $PHP_VERSION_SHORT
printf "PHP version (full):\n%s\n%s\n" "$PHP_VERSION" $LOG_DELIMETR
printf "PHP.INI: %s\n" "$PHP_INI_FILE"
printf "Extensions directory: %s\n%s\n" $EXTENSION_DIR $LOG_DELIMETR
printf "Extension virgil_crypto_php: %s\n%s" "$STATUS_VIRGIL_CRYPTO_PHP"
printf "Extension vsce_phe_php: %s\n%s\n" "$STATUS_VSCE_PHE_PHP" $LOG_DELIMETR
### <-- LOG
