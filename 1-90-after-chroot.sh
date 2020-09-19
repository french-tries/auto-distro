#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
PRIMARY_DATASET_NAME=`python3 bin/configuration.py primary_dataset_name`
PRIMARY_DISTRO=`python3 bin/configuration.py primary_distro`

# mounting inside chroot is wonky
if [ "$PRIMARY_DISTRO" = "False" ] ; then  
    zfs umount ${ROOT_POOL_NAME}/ROOT/${PRIMARY_DATASET_NAME}
    zfs unload-key ${ROOT_POOL_NAME}/ROOT/${PRIMARY_DATASET_NAME}
    
    zfs set mountpoint=/ ${ROOT_POOL_NAME}/ROOT/${PRIMARY_DATASET_NAME}
    rmdir /mnt/tmp/primary
fi

mount | grep -v zfs | tac | awk '/\/mnt/ {print $3}' | \
    xargs -i{} umount -lf {}
zpool export -a

reboot
