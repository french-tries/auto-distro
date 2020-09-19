#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
BOOT_POOL_NAME=`python3 bin/configuration.py boot_pool_name`
SYSTEM_DATASET_NAME=`python3 bin/configuration.py system_dataset_name`
USER_DATASET_NAME=`python3 bin/configuration.py user_dataset_name`
ROOT_USER_DATASET_NAME=`python3 bin/configuration.py root_user_dataset_name`

# Snapshot install
zfs snapshot ${BOOT_POOL_NAME}/BOOT/${SYSTEM_DATASET_NAME}@install
zfs snapshot -r ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}@install
zfs snapshot ${ROOT_POOL_NAME}/USERDATA/${ROOT_USER_DATASET_NAME}@install
zfs snapshot ${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME}@install

exit
