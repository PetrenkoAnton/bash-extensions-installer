#!/usr/bin/env bash

clear

print() {
	printf "$1\n"
}

list_ext="vsce_phe_php vscf_foundation_php vscp_pythia_php vscr_ratchet_php"

	for ext in $list_ext; do
		
		ini_cli="/etc/php/7.2/cli/conf.d/$ext.ini"
		ini_fpm="/etc/php/7.2/fpm/conf.d/$ext.ini"

		if [ -f "$ini_cli" ]; then
			sudo rm "$ini_cli"
		fi

		if [ -f "$ini_fpm" ]; then
			sudo rm "$ini_fpm"
		fi
	done

for ext in $list_ext; do

	so="/usr/lib/php/20170718/$ext.so"

	if [ -f "$so" ]; then
		sudo rm "$so"
	fi
done

sudo service php7.2-fpm restart

print "[DONE]"