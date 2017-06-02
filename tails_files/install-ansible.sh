#!/bin/bash
#
#
# Setup virtualenv environment and install ansible


setup_python_deps() {
	which virtualenv &> /dev/null || sudo su -c "echo '### Downloading depedencies'; \
						     apt-get update && \
						     apt-get install -y \
						     python-virtualenv \
						     python-pip \
						     ccontrol \
						     virtualenv \
						     libffi-dev \	
						     libssl-dev \	
						     libpython2.7-dev"
}

setup_ansible() {
	if [ ! -d ./.venv/bin/activate ]; then
		virtualenv &> /dev/null || setup_python_deps
		torify virtualenv .venv
	fi

	. ./.venv/bin/activate
	torify pip install -r install_files/ansible-base/requirements.txt
	echo "### SD pre-reqs installed"
}


ls .venv/bin/ansible &> /dev/null
if [ "$?" == "0" ]; then
	if [ "$1" == "update" ]; then
		. ./.venv/bin/activate && torify pip install -U -r install_files/ansible-base/requirements.txt
	else
		echo "### SD pre-reqs already installed"
	fi
else
	setup_ansible
fi
