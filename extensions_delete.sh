#!/usr/bin/env bash

list_ext="vsce_phe_php vscf_foundation_php vscp_pythia_php vscr_ratchet_php"

for ext in $list_ext; do

	so="/usr/lib/php/20170718/$ext.so"
	ini="/etc/php/7.2/fpm/conf.d/$ext.ini"

	if [ -f "$so" ]; then
		sudo rm "$so"
	fi

	if [ -f "$ini" ]; then
		sudo rm "$ini"
	fi
done

sudo service php7.2-fpm reload