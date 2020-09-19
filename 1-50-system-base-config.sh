#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

HOSTNAME=`python3 bin/configuration.py hostname`
NETWORK_INTERFACE=`python3 bin/configuration.py network_interface`
ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
SYSTEM_DATASET_NAME=`python3 bin/configuration.py system_dataset_name`
PRIMARY_DATASET_NAME=`python3 bin/configuration.py primary_dataset_name`
PRIMARY_DISTRO=`python3 bin/configuration.py primary_distro`
ROOT_USER_DATASET_NAME=`python3 bin/configuration.py root_user_dataset_name`
USER_DATASET_NAME=`python3 bin/configuration.py user_dataset_name`
USER_NAME=`python3 bin/configuration.py username`
DISK=`python3 bin/configuration.py disk`

# Configure the hostname
echo ${HOSTNAME} > /mnt/etc/hostname

# Configure the network interface
echo "127.0.1.1       ${HOSTNAME}" >> /mnt/etc/hosts

cat >> /mnt/etc/network/interfaces.d/${NETWORK_INTERFACE}<< EOF
auto ${NETWORK_INTERFACE}
iface ${NETWORK_INTERFACE} inet dhcp
EOF

# Configure the package sources
cat > /mnt/etc/apt/sources.list<< EOF
deb http://deb.debian.org/debian buster main contrib non-free
deb-src http://deb.debian.org/debian buster main contrib non-free
EOF

cat > /mnt/etc/apt/sources.list.d/buster-backports.list<< EOF
deb http://deb.debian.org/debian buster-backports main contrib non-free
deb-src http://deb.debian.org/debian buster-backports main contrib non-free
EOF

cat >> /mnt/etc/apt/preferences.d/90_zfs<< EOF
Package: libnvpair1linux libuutil1linux libzfs2linux libzfslinux-dev libzpool2linux python3-pyzfs pyzfs-doc spl spl-dkms zfs-dkms zfs-dracut zfs-initramfs zfs-test zfsutils-linux zfsutils-linux-dev zfs-zed
Pin: release n=buster-backports
Pin-Priority: 990
EOF

cat >> /mnt/etc/fstab<< EOF
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/opt /opt  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/srv /srv  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/usr/local /usr/local  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/cache /var/cache  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/games /var/games  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/AccountsService /var/lib/AccountsService  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/NetworkManager /var/lib/NetworkManager  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/apt /var/lib/apt  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/dpkg /var/lib/dpkg  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/lib/nfs  /var/lib/nfs  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/log /var/log  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/mail /var/mail  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/snap /var/snap  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/spool /var/spool  zfs defaults    0 0
${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME}/var/www /var/www  zfs defaults    0 0

${ROOT_POOL_NAME}/USERDATA/${ROOT_USER_DATASET_NAME} /root  zfs defaults    0 0
${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME} /home/${USER_NAME}  zfs defaults    0 0
${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME}/cache /home/${USER_NAME}/.cache  zfs defaults    0 0
EOF 

# mounting inside chroot is wonky
if [ "$PRIMARY_DISTRO" = "False" ] ; then  
    mkdir /mnt/tmp/primary
    zfs set mountpoint=/tmp/primary ${ROOT_POOL_NAME}/ROOT/${PRIMARY_DATASET_NAME}
    zfs load-key ${ROOT_POOL_NAME}/ROOT/${PRIMARY_DATASET_NAME}
    zfs mount ${ROOT_POOL_NAME}/ROOT/${PRIMARY_DATASET_NAME}
fi

mount --bind . /mnt/mnt

# bind and chroot
mount --rbind /dev  /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys  /mnt/sys
chroot /mnt /usr/bin/env DISK=$DISK bash --login
