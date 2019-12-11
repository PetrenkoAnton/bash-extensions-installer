#!/usr/bin/env bash

clear

print() {
	printf "$1\n"
}

list_ext="vsce_phe_php vscf_foundation_php vscp_pythia_php vscr_ratchet_php"

ini_cli="/etc/php/7.2/cli/conf.d/virgil_crypto.ini"
ini_fpm="/etc/php/7.2/fpm/conf.d/virgil_crypto.ini"

if [ -f "$ini_cli" ]; then
    sudo rm "$ini_cli"
fi

if [ -f "$ini_fpm" ]; then
    sudo rm "$ini_fpm"
fi

for ext in $list_ext; do

	so="/usr/lib/php/20170718/$ext.so"

	if [ -f "$so" ]; then
		sudo rm "$so"
	fi
done

sudo service php7.2-fpm restart

print "[DONE]"