clear

### MAIN CONFIG -->
LATEST_VERSION="2.6.3"
PHP="php"
EXTENSION_NAME_VIRGIL_CRYPTO_PHP="virgil_crypto_php"
EXTENSION_NAME_VSCE_PHE_PHP="vsce_phe_php"
### <-- MAIN_CONFIG

### LOG FORMATTER -->
LOG_DELIMETR_PRIMARY="==========================================================="
LOG_DELIMETR_SECONDARY="-----------------------------------------------------------"
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

### GET EXTENSION FILE --> 
# wget -O ./for-dev/archive.tgz -c --progress=dot https://cdn.virgilsecurity.com/virgil-crypto/php/virgil-crypto-2.6.3-php-7.3-linux-x86_64.tgz
# tar xvzf ./for-dev/archive.tgz
# cp ./for-dev/virgil-crypto-2.6.3-php-7.3-linux-x86_64/lib/virgil_crypto_php.so ./for-dev/virgil_crypto_php.so
# rm -rf ./for-dev/virgil-crypto-2.6.3-php-7.3-linux-x86_64
### <-- GET EXTENSION FILE

### FORMAT LINK -->
LINK_CRYPTO_NAME="virgil-crypto"
LINK_LANGUAGE=$PHP
LINK_ARCHIVE_CRYPTO_VERSION=$LATEST_VERSION
LINK_ARCHIVE_PHP_VERSION=$PHP_VERSION_SHORT
LINK_ARCIVE_LANGUAGE=$PHP
LINK_ARCIVE_OS=$OS_FORMATTED
LINK_ARCHIVE_OUTPUT_FORMAT="tgz"
LINK_ARCHIVE_FORMAT="virgil-crypto-$LINK_ARCHIVE_CRYPTO_VERSION-$LINK_ARCIVE_LANGUAGE-$LINK_ARCHIVE_PHP_VERSION-$LINK_ARCIVE_OS.$LINK_ARCHIVE_OUTPUT_FORMAT"
LINK_MAIN_FORMAT="https://cdn.virgilsecurity.com/$LINK_CRYPTO_NAME/$LINK_LANGUAGE/$LINK_ARCHIVE_FORMAT"
### <-- FORMAT LINK

### LINK CHECKER -->
if [ ! -f $LINK_MAIN_FORMAT ]; then
  echo "=> File doesn't exist"
fi
### <-- LINK CHECKER

### NGINX RELOADER -->
sudo service nginx reload
### <-- NGINX RELOADER

### APACHE RELOADER -->
sudo service apache2 reload
### <-- APACHE RELOADER

printf "%s\n:::CONFIGURATION:::\n%s\n" $LOG_DELIMETR_PRIMARY $LOG_DELIMETR_PRIMARY
printf "IN URL: %s\n%s\n" "https://cdn.virgilsecurity.com/virgil-crypto/php/virgil-crypto-2.6.3-php-7.3-linux-x86_64.tgz" $LOG_DELIMETR_SECONDARY
printf "OU URL: %s\n%s\n" "$LINK_MAIN_FORMAT" $LOG_DELIMETR_SECONDARY
printf "OS: %s\n%s\n" "$UNAME" $LOG_DELIMETR_SECONDARY
printf "PHP version (short): %s\n%s\n" $PHP_VERSION_SHORT $LOG_DELIMETR_SECONDARY
printf "PHP version (full):\n%s\n%s\n" "$PHP_VERSION" $LOG_DELIMETR_SECONDARY
printf "PHP.INI: %s\n%s\n" "$PHP_INI_FILE" $LOG_DELIMETR_SECONDARY
printf "Extensions directory: %s\n%s\n" $EXTENSION_DIR $LOG_DELIMETR_SECONDARY
printf "Extension virgil_crypto_php: %s\n%s\n" "$STATUS_VIRGIL_CRYPTO_PHP" $LOG_DELIMETR_SECONDARY
printf "Extension vsce_phe_php: %s\n%s\n" "$STATUS_VSCE_PHE_PHP" $LOG_DELIMETR_PRIMARY
