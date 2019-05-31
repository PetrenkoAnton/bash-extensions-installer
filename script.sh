DELIMETR="=========="
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

clear

wget -c --progress=dot https://cdn.virgilsecurity.com/virgil-crypto/php/virgil-crypto-2.6.3-php-7.3-linux-x86_64.tgz
tar xvzf virgil-crypto-2.6.3-php-7.3-linux-x86_64.tgz
cp ./virgil-crypto-2.6.3-php-7.3-linux-x86_64/lib/virgil_crypto_php.so ./virgil_crypto_php.so
rm -rf ./virgil-crypto-2.6.3-php-7.3-linux-x86_64

echo "OS:"
uname
echo $DELIMETR

echo "PHP version (short):"
echo $PHP_VERSION_SHORT
echo $DELIMETR

echo "PHP version (full):"
echo $PHP_VERSION
echo $DELIMETR

echo "PHP.INI:"
#echo $PHP_INI_FILE | awk -F"=> " '{print $2}'
echo $PHP_INI_FILE
echo $DELIMETR

echo "Extension directory:"
echo $EXTENSION_DIR
echo $DELIMETR

echo "Extension virgil_crypto_php":
if [ -z "$VIRGIL_CRYPTO_PHP" ]
then
      echo "Loaded"
else
      echo "Not loaded"
fi
echo $DELIMETR

echo "Extension vsce_phe_php":
if [ -z "$VSCE_PHE_PHP" ]
then
      echo "Loaded"
else
      echo "Not loaded"
fi
echo $DELIMETR
