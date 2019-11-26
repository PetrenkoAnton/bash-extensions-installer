#!/usr/bin/env bash

clear

print() {
	printf "$1\n"
}

list_ext="vsce_phe_php vscf_foundation_php vscp_pythia_php vscr_ratchet_php"

ini="/etc/php/7.2/fpm/conf.d/virgil_crypto.ini"

if [ -f "$ini" ]; then
	sudo rm "$ini"
fi

for ext in $list_ext; do

	so="/usr/lib/php/20170718/$ext.so"

	if [ -f "$so" ]; then
		sudo rm "$so"
	fi
done

sudo service php7.2-fpm restart

print "[DONE]"