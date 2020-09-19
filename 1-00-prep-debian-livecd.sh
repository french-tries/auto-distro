#!/bin/bash

# from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

# Add contrib to livecd sources.list
sed -i '/^deb http:\/\/deb.debian.org\/debian\/ / s/$/ contrib/' /etc/apt/sources.list
echo "deb http://deb.debian.org/debian buster-backports main contrib" >> /etc/apt/sources.list

apt update

# install zfs
apt install --yes debootstrap gdisk dkms dpkg-dev linux-headers-$(uname -r)
apt install --yes -t buster-backports --no-install-recommends zfs-dkms
modprobe zfs
apt install --yes -t buster-backports zfsutils-linux
