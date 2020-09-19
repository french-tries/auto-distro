#!/bin/bash

# based from https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/Debian%20Buster%20Root%20on%20ZFS.html

DEBOOTSTRAP_SUITE=`python3 bin/configuration.py debootstrap_suite`

debootstrap ${DEBOOTSTRAP_SUITE} /mnt
