#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

DISK=`python3 bin/configuration.py disk`
UEFI_BOOT=`python3 bin/configuration.py uefi_boot`
BOOT_POOL_NAME=`python3 bin/configuration.py boot_pool_name`
ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
FORMAT=`python3 bin/configuration.py format`

if [ "$FORMAT" = "True" ] ; then
    
    # @todo must clear then restart, same session does not work

    # clear
    sgdisk --zap-all $DISK
    zpool labelclear -f $DISK

    ### partitioning

    # EFI or bios partition
    if [ "$UEFI_BOOT" = True ] ; then
        sgdisk     -n2:1M:+512M   -t2:EF00 $DISK
    else
        sgdisk -a1 -n1:24K:+1000K -t1:EF02 $DISK
    fi

    #Run this for the boot pool:
    sgdisk     -n3:0:+1G      -t3:BF01 $DISK

    # root pool
    sgdisk     -n4:0:0        -t4:BF00 $DISK

    # wait for changes to propagate
    sleep 1

    ### zpool setup

    # boot pool
    zpool create \
        -o ashift=12 -d \
        -o feature@async_destroy=enabled \
        -o feature@bookmarks=enabled \
        -o feature@embedded_data=enabled \
        -o feature@empty_bpobj=enabled \
        -o feature@enabled_txg=enabled \
        -o feature@extensible_dataset=enabled \
        -o feature@filesystem_limits=enabled \
        -o feature@hole_birth=enabled \
        -o feature@large_blocks=enabled \
        -o feature@lz4_compress=enabled \
        -o feature@spacemap_histogram=enabled \
        -o feature@zpool_checkpoint=enabled \
        -O acltype=posixacl -O canmount=off -O compression=lz4 \
        -O devices=off -O normalization=formD -O relatime=on -O xattr=sa \
        -O mountpoint=/boot -R /mnt \
        ${BOOT_POOL_NAME} ${DISK}-part3

    # root pool (without encryption)
    zpool create \
        -o ashift=12 \
        -O acltype=posixacl -O canmount=off -O compression=lz4 \
        -O dnodesize=auto -O relatime=on \
        -O xattr=sa -O mountpoint=/ -R /mnt \
        ${ROOT_POOL_NAME} ${DISK}-part4
        
else
    zpool import -fR /mnt ${ROOT_POOL_NAME}
    zpool import -fR /mnt ${BOOT_POOL_NAME}
fi
