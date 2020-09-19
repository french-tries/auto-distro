#!/bin/bash

USER_NAME=`python3 bin/configuration.py username`
HOSTNAME=`python3 bin/configuration.py hostname`
DATA_MOUNT=`python3 bin/configuration.py data_mount`
DATA_PATH=`python3 bin/configuration.py data_path`

# generate zfs mount script + unison config
python3 bin/gen-zfs-mount.py
chmod a+x /usr/local/bin/data-mount.sh
 
# add small scripts to /usr/local/bin

cp -R files/opt/* /opt
cp -R files/local/etc/* /usr/local/etc
cp -R files/local/bin/* /usr/local/bin

# gocryptfs

apt install gocryptfs

mkdir -p /media/${HOSTNAME}/gocrypt

cat >> /etc/fstab << EOF

${DATA_MOUNT}/${DATA_PATH}/gocrypt /media/${HOSTNAME}/gocrypt      fuse./usr/bin/gocryptfs         nodev,nosuid,allow_other,quiet,noauto   0 0
EOF

