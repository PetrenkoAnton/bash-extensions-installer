#!/usr/bin/env bash

list_so="vsce_phe_php.so vscf_foundation_php.so vscp_pythia_php.so vscr_ratchet_php.so"

for so in $list_so; do
	sudo rm /usr/lib/php/20170718/$so
done

sudo service nginx reload