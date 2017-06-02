#!/bin/bash
#
#
#
#

export ANSIBLE_PATH=./install_files/ansible-base
export SITE_CONFIG="group_vars/all/site-specific"

if [[ -f ".venv/bin/ansible-playbook" && -f "${ANSIBLE_PATH}/${SITE_CONFIG}" ]]; then
	echo "$PATH" | grep -q ".venv" || export PATH=".venv/bin:$PATH"
else
	if [ "$1" != "setup" ]; then
	    echo "[WARNING] You are missing pre-reqs"
        test -f .venv/bin/ansible-playbook || printf "\t * Ansible is not installed\n"
        test -f "${ANSIBLE_PATH}/${SITE_CONFIG}" || printf "\t * Site config is not ready\n"
	fi
fi


activate_venv() {
    source .venv/bin/activate
}

case "$1" in
	activate)
        if [ "$0" == "bash" ]; then 
            echo "You must source this command - 'source $0 activate'"
            exit 1
        fi
		activate_venv
		;;
        
    sdconfig)
        activate_venv
        cd "$ANSIBLE_PATH" || exit
        ./configure || echo "[WARNING] Run $0 sdconfigure again to resolve issues or edit ${ANSIBLE_PATH}/${SITE_CONFIG} manually"
        ;;

    setup)
		"tails_files/install-ansible.sh" "$2"
		;;

	install)
		activate_venv
		cd "$ANSIBLE_PATH" || exit 1

        if [ ! -f "$SITE_CONFIG" ]; then
            echo "[ERROR] You need to configure SD first. Run $0 sdconfig"
            exit 1
        fi

        if [ ! -z "$SD_USER" ]; then
            user="$SD_USER"
        else
            user=$(grep ssh_user "$SITE_CONFIG" | cut -d':' -f 2)
        fi
        echo "You'll now be prompted for the sudo credentials for '$user' on the remote servers"
		./securedrop-prod.yml -u "$user" -K
		;;

	tailsconfig)
		sudo ./tails_files/install.sh
		;;

	*)
		echo -e "\nSecureDrop Usage: $0 {prod|setup|activate|tailsconfig}"
		printf "\t- activate: Use to activate the local virtualenv.\n"
		printf "\t- setup: Install SD pre-reqs\n"
		printf "\t- sdconfig: Configure SD site settings\n"
		printf "\t- install: Install/Update/Synchronize SecureDrop\n"
		printf "\t- tailsconfig: Run after securedrop is installed.\n"
		exit 1
        ;;
esac
