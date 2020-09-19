 #!/bin/bash

USER_NAME=`python3 bin/configuration.py username`
HOSTNAME=`python3 bin/configuration.py hostname`
SSH_SERVER_HOSTNAME=`python3 bin/configuration.py ssh_server_hostname`
SSH_SERVER_PORT=`python3 bin/configuration.py ssh_server_port`
SSH_SERVER_USERNAME=`python3 bin/configuration.py ssh_server_username`
SSH_SERVER_ADDRESS=`python3 bin/configuration.py ssh_server_address`
SERVER_DATA_MOUNT=`python3 bin/configuration.py server_data_mount`
SERVER_DATASET_NAME=`python3 bin/configuration.py system_dataset_name`

# @todo hardcoded
# backups to server

cat >> /etc/cron.daily/backup-to-server << EOF

rsync -avz -e 'ssh -p ${SSH_SERVER_PORT} -i /home/${USER_NAME}/.ssh/keys/${HOSTNAME}-${SSH_SERVER_HOSTNAME}.rsa' \
    --delete --include-from=/usr/local/etc/rsync_linux_include.cfg  \
    / ${SSH_SERVER_USERNAME}@${SSH_SERVER_ADDRESS}:${SERVER_DATA_MOUNT}/backup/${HOSTNAME}/${SERVER_DATASET_NAME}

EOF
