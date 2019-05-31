clear

DELIMETR_PRIMARY="==========================================================="
DELIMETR_SECONDARY="-----------------------------------------------------------"
PHP_VERSION=$(php -v)
EXTENSION_DIR=$(php-config --extension-dir)
# PHP_INI_FILE=$(php -i | grep /.+/php.ini -oE)
PHP_INI_FILE=$(php -i | grep "Configuration File (php.ini) Path")
PHP_INI_FILE=$PHP_INI_FILE

VIRGIL_CRYPTO_PHP=$(php -m | grep virgil_crypto_php)
VSCE_PHE_PHP=$(php -m | grep vsce_phe_php)

set -- $PHP_VERSION
PHP_VERSION_STRING="$2"
PHP_VERSION_MAJOR=`echo $PHP_VERSION_STRING | cut -f 1 -d'.'`
PHP_VERSION_MINOR=`echo $PHP_VERSION_STRING | cut -f 2 -d'.'`
PHP_VERSION_SHORT=$PHP_VERSION_MAJOR.$PHP_VERSION_MINOR
UNAME=$(uname)
OUT_URL="temp"
LATEST_VERSION="2.6.3"

if [ -z "$VIRGIL_CRYPTO_PHP" ]
then
      STATUS_VIRGIL_CRYPTO_PHP="LOADED"
else
      STATUS_VIRGIL_CRYPTO_PHP="NOT LOADED"
fi

if [ -z "$VSCE_PHE_PHP" ]
then
      STATUS_VSCE_PHE_PHP="LOADED"
else
      STATUS_VSCE_PHE_PHP="${RED}NOT LOADED"
fi

wget -O ./for-dev/archive.tgz -c --progress=dot https://cdn.virgilsecurity.com/virgil-crypto/php/virgil-crypto-2.6.3-php-7.3-linux-x86_64.tgz
tar xvzf ./for-dev/archive.tgz
# cp ./for-dev/virgil-crypto-2.6.3-php-7.3-linux-x86_64/lib/virgil_crypto_php.so ./for-dev/virgil_crypto_php.so
# rm -rf ./for-dev/virgil-crypto-2.6.3-php-7.3-linux-x86_64

printf "%s\n:::CONFIGURATION:::\n%s\n" $DELIMETR_PRIMARY $DELIMETR_PRIMARY

printf "IN URL: %s\n%s\n" "https://cdn.virgilsecurity.com/virgil-crypto/php/virgil-crypto-2.6.3-php-7.3-linux-x86_64.tgz" $DELIMETR_SECONDARY
printf "OUT URL: %s\n%s\n" "$OUT_URL" $DELIMETR_SECONDARY
printf "OS: %s\n%s\n" "$UNAME" $DELIMETR_SECONDARY
printf "PHP version (short): %s\n%s\n" $PHP_VERSION_SHORT $DELIMETR_SECONDARY
printf "PHP version (full):\n%s\n%s\n" "$PHP_VERSION" $DELIMETR_SECONDARY
printf "PHP.INI: %s\n%s\n" "$PHP_INI_FILE" $DELIMETR_SECONDARY
printf "Extensions directory: %s\n%s\n" $EXTENSION_DIR $DELIMETR_SECONDARY
printf "Extension virgil_crypto_php: %s\n%s\n" "$STATUS_VIRGIL_CRYPTO_PHP" $DELIMETR_SECONDARY
printf "Extension vsce_phe_php: %s\n%s\n" "$STATUS_VSCE_PHE_PHP" $DELIMETR_PRIMARY
