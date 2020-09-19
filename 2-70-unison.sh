 #!/bin/bash

USER_NAME=`python3 bin/configuration.py username`
HOSTNAME=`python3 bin/configuration.py hostname`
SSH_SERVER_HOSTNAME=`python3 bin/configuration.py ssh_server_hostname`
SSH_SERVER_USERNAME=`python3 bin/configuration.py ssh_server_username`
SSH_SERVER_ADDRESS=`python3 bin/configuration.py ssh_server_address`
SSH_SERVER_PORT=`python3 bin/configuration.py ssh_server_port`

# as user

# ssh

mkdir -p /home/${USER_NAME}/.ssh/keys
ssh-keygen -t rsa -f /home/${USER_NAME}/.ssh/keys/${HOSTNAME}-${SSH_SERVER_HOSTNAME}.rsa

ssh-copy-id -p ${SSH_SERVER_PORT} -i /home/${USER_NAME}/.ssh/keys/${HOSTNAME}-${SSH_SERVER_HOSTNAME}.rsa.pub ${SSH_SERVER_USERNAME}@${SSH_SERVER_ADDRESS}

python3 bin/gen-ssh-entry.py

# unison

sudo apt install --yes curl
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)

opam init
eval $(opam env)
opam switch create 4.07.1
eval $(opam env)

opam install unison

python3 bin/gen-data-server-unison.py
