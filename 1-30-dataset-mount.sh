#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
SYSTEM_DATASET_NAME=`python3 bin/configuration.py system_dataset_name`
USER_DATASET_NAME=`python3 bin/configuration.py user_dataset_name`
ROOT_USER_DATASET_NAME=`python3 bin/configuration.py root_user_dataset_name`
USER_NAME=`python3 bin/configuration.py username`

# mount

mkdir -p /mnt/home/${USER_NAME} /mnt/opt /mnt/srv /mnt/usr/local /mnt/var/cache /mnt/var/games /mnt/var/lib/AccountsService /mnt/var/lib/NetworkManager \
    /mnt/var/lib/NetworkManager /mnt/var/lib/apt /mnt/var/lib/dpkg /mnt/var/lib/nfs /mnt/var/log /mnt/var/mail /mnt/var/snap /mnt/var/spool /mnt/var/www /mnt/root
mkdir -p /mnt/home/${USER_NAME}/.cache

mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/opt /mnt/opt
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/srv /mnt/srv
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/usr/local /mnt/usr/local
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/cache /mnt/var/cache
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/games /mnt/var/games
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/AccountsService /mnt/var/lib/AccountsService
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/NetworkManager /mnt/var/lib/NetworkManager
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/apt /mnt/var/lib/apt
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/dpkg /mnt/var/lib/dpkg
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/nfs  /mnt/var/lib/nfs
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/log /mnt/var/log
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/mail /mnt/var/mail
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/snap /mnt/var/snap
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/spool /mnt/var/spool
mount -t zfs ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/www /mnt/var/www

mount -t zfs ${ROOT_POOL_NAME}/USERDATA/${ROOT_USER_DATASET_NAME} /mnt/root
mount -t zfs ${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME} /mnt/home/${USER_NAME}
mount -t zfs ${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME}/cache /mnt/home/${USER_NAME}/.cache
