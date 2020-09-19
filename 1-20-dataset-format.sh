#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

BOOT_POOL_NAME=`python3 bin/configuration.py boot_pool_name`
ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
SYSTEM_DATASET_NAME=`python3 bin/configuration.py system_dataset_name`
USER_DATASET_NAME=`python3 bin/configuration.py user_dataset_name`
ROOT_USER_DATASET_NAME=`python3 bin/configuration.py root_user_dataset_name`

####### verify zfs and stuff exists

#...
if [ "$(ls -A /mnt)" ] ; then
  echo "/mnt directory must be empty."
  exit 1
fi

# check if SYSTEM_DATASET_NAME is already used 
case `zfs list | grep "${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}" >/dev/null; echo $?` in
  0)
    ;;
  1)
    ;;
  *)
    echo "System dataset name ${SYSTEM_DATASET_NAME} already used"
    exit 1
    ;;
esac

case `zfs list | grep "${BOOT_POOL_NAME}/BOOT/${SYSTEM_DATASET_NAME}" >/dev/null; echo $?` in
  0)
    ;;
  1)
    ;;
  *)
    echo "System dataset name ${SYSTEM_DATASET_NAME} already used"
    exit 1
    ;;
esac

### main datasets

case `zfs list | grep "${ROOT_POOL_NAME}/ROOT" >/dev/null; echo $?` in
  0)
    ;;
  1)
    zfs create -o canmount=off -o mountpoint=none ${ROOT_POOL_NAME}/ROOT
    ;;
  *)
    echo "An error occured searching for the ROOT dataset"
    exit 1
    ;;
esac

case `zfs list | grep "${ROOT_POOL_NAME}/USERDATA" >/dev/null; echo $?` in
  0)
    ;;
  1)
    zfs create -o canmount=off -o mountpoint=none ${ROOT_POOL_NAME}/USERDATA
    ;;
  *)
    echo "An error occured searching for the USERDATA dataset"
    exit 1
    ;;
esac

case `zfs list | grep "${BOOT_POOL_NAME}/BOOT" >/dev/null; echo $?` in
  0)
    ;;
  1)
    zfs create -o canmount=off -o mountpoint=none ${BOOT_POOL_NAME}/BOOT
    ;;
  *)
    echo "An error occured searching for the BOOT dataset"
    exit 1
    ;;
esac

# system dataset
zfs create -o canmount=noauto -o mountpoint=/ -o encryption=aes-256-gcm \
    -o keyformat=passphrase ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}
zfs mount ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}

zfs create -o canmount=noauto -o mountpoint=/boot ${BOOT_POOL_NAME}/BOOT/${SYSTEM_DATASET_NAME}
zfs mount ${BOOT_POOL_NAME}/BOOT/${SYSTEM_DATASET_NAME}

# sub datasets (the same as the ubuntu 20.04 installer (to be able to use zsys???))

# I had problems using zfs mountpoints when multibooting
# (using dataset from another system)

zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/opt
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/srv
zfs create -o canmount=off \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/usr
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/usr/local
zfs create -o canmount=off \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var
zfs create -o com.sun:auto-snapshot=false -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/cache
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/games
zfs create -o canmount=off \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/AccountsService
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/NetworkManager
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/apt
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/dpkg
zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/nfs 
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/log
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/mail
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/snap
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/spool
zfs create -o mountpoint=legacy \
    ${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/www

# user datasets

case `zfs list | grep "${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME}" >/dev/null; echo $?` in
  0)
    ;;
  1)
    zfs create -o mountpoint=legacy ${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME}
    zfs create -o mountpoint=legacy ${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME}/cache
    ;;
  *)
    echo "An error occured searching for the USER dataset"
    exit 1
    ;;
esac

case `zfs list | grep "${ROOT_POOL_NAME}/USERDATA/${ROOT_USER_DATASET_NAME}" >/dev/null; echo $?` in
  0)
    ;;
  1)
    zfs create -o mountpoint=legacy ${ROOT_POOL_NAME}/USERDATA/${ROOT_USER_DATASET_NAME}
    ;;
  *)
    echo "An error occured searching for the ROOT USER dataset"
    exit 1
    ;;
esac
