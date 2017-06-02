#!/bin/bash
#
#
#
#

ANSIBLE_PATH=./install_files/ansible-base

if [ -f .venv/bin/ansible-playbook ]; then
	echo "$PATH" | grep -q ".venv" || export PATH=".venv/bin:$PATH"
else
	if [ "$1" != "setup" ]; then
	    echo "[WARNING] Looks like you need to run 'setup'. You are missing pre-reqs"
	fi
fi


activate_venv() {
    source .venv/bin/activate
}

case "$1" in
	activate)
		activate_venv
		;;
	setup)
		"tails_files/install-ansible.sh" "$2"
		;;
	run)
		activate_venv
		cd "$ANSIBLE_PATH"
		./securedrop-prod.yml
		;;
	postconfig)
		sudo ./tails_files/install.sh
		;;
	*)
		echo "SecureDrop Usage: $0 {prod|setup|activate}"
		echo "- activate: Use to activate the local virtualenv. Use like 'source $0 activate'"
		echo "- setup: Configure SD pre-reqs"
		echo "- run: Install/Update/Synchronize SecureDrop"
		echo "- postconfig: Run after securedrop is installed"
		exit 1
        ;;
esac
