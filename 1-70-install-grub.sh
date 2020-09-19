#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
SYSTEM_DATASET_NAME=`python3 bin/configuration.py system_dataset_name`
PRIMARY_DATASET_NAME=`python3 bin/configuration.py primary_dataset_name`
PRIMARY_DISTRO=`python3 bin/configuration.py primary_distro`
UEFI_BOOT=`python3 bin/configuration.py uefi_boot`
DISK=`python3 bin/configuration.py disk`

if [ `grub-probe /boot` != "zfs" ] ; then
    echo "/boot partition not recognised as zfs. exiting."
    exit 1
fi

# Refresh the initrd files:
update-initramfs -c -k all

# Workaround GRUB’s missing zpool-features support
#sed "/^GRUB_CMDLINE_LINUX=/ s/^/GRUB_CMDLINE_LINUX=\"root=ZFS=${ROOT_POOL_NAME}\/ROOT\/${SYSTEM_DATASET_NAME}\"\n# /" \
sed -i "/^GRUB_CMDLINE_LINUX=/ s/^/GRUB_CMDLINE_LINUX=\"root=ZFS=${ROOT_POOL_NAME}\/ROOT\/${SYSTEM_DATASET_NAME}\"\n# /" /etc/default/grub

# Update the boot configuration
update-grub

# Install the boot loader
if [ "$PRIMARY_DISTRO" = "True" ] ; then  
    if [ "$UEFI_BOOT" = true ] ; then
        grub-install --target=x86_64-efi --efi-directory=/boot/efi \
            --bootloader-id=debian --recheck --no-floppy
    else
        grub-install $DISK
    fi

# add option in primary boot if secondary (when the primary runs 'update-grub')
else
    sed -n '/^menuentry/,/^}/p' /boot/grub/grub.cfg | \
        sed -e "/^\techo/,/^\tinitrd/c\ \techo\t'Loading config ...'\n\tconfigfile \/BOOT\/${SYSTEM_DATASET_NAME}@\/grub\/grub.cfg\n" >> /tmp/primary/etc/grub.d/40_custom
fi

# Fix filesystem mount ordering
# necessary if using legacy mounts?


