#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

apt install --yes python3

USER_NAME=`python3 bin/configuration.py username`
DISK=`python3 bin/configuration.py disk`
UEFI_BOOT=`python3 bin/configuration.py uefi_boot`
POPCON=`python3 bin/configuration.py popcon`

# Configure a basic system environment
ln -s /proc/self/mounts /etc/mtab
apt update

apt install --yes locales
dpkg-reconfigure locales
dpkg-reconfigure tzdata

# Install ZFS in the chroot environment for the new system
apt install --yes dpkg-dev linux-headers-amd64 linux-image-amd64
apt install --yes zfs-initramfs
echo REMAKE_INITRD=yes > /etc/dkms/zfs.conf

# Install grub 
# (note: only install grub bootloader when prompted when installing primary distro)
if [ "$UEFI_BOOT" = "True" ] ; then
    apt install dosfstools
    mkdosfs -F 32 -s 1 -n EFI ${DISK}-part2
    mkdir /boot/efi
    echo PARTUUID=$(blkid -s PARTUUID -o value ${DISK}-part2) \
        /boot/efi vfat nofail,x-systemd.device-timeout=1 0 1 >> /etc/fstab
    mount /boot/efi
    apt install --yes grub-efi-amd64 shim-signed
else
    apt install --yes grub-pc
fi

# Set a root password
passwd

# Enable importing bpool
cat > /etc/systemd/system/zfs-import-bpool.service<< EOF
[Unit]
DefaultDependencies=no
Before=zfs-import-scan.service
Before=zfs-import-cache.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/sbin/zpool import -N -o cachefile=none bpool

[Install]
WantedBy=zfs-import.target
EOF

systemctl enable zfs-import-bpool.service

# Mount a tmpfs to /tmp
cp /usr/share/systemd/tmp.mount /etc/systemd/system/
systemctl enable tmp.mount

if [ "$POPCON" = "True" ] ; then
    apt install --yes popularity-contest
fi

# Create a user account
adduser ${USER_NAME}

cp -a /etc/skel/. /home/${USER_NAME}
chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}
usermod -a -G audio,cdrom,dip,floppy,netdev,plugdev,sudo,video ${USER_NAME}
