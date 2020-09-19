#!/bin/bash

GPU_TYPE=`python3 bin/configuration.py gpu_type`
MINIMAL=`python3 bin/configuration.py minimal`
WORK=`python3 bin/configuration.py work`

# install amd gpu drivers
if [ "$GPU_TYPE" = "amd" ] ; then
    apt install --yes firmware-linux-nonfree libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-all
fi

# install minimal kde
apt install --yes kde-plasma-desktop

# install kde software
apt install --yes kate gwenview krita okular ktorrent yakuake kcharselect krename partitionmanager

# install common software
apt install --yes firefox-esr smplayer htop nfs-common xbindkeys xautomation git bash-completion keepassxc ufw

if [ "$MINIMAL" = "False" ] ; then
    apt install --yes claws-mail gnucash libreoffice chromium clementine retext 
fi

# skype, multibootusb, kaudiocreator

if [ "$WORK" = "True" ] ; then
    apt install --yes arduino git kdevelop kdevelop-python wget
    
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add - 
    echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list 
    sudo apt update && sudo apt install codium 
    
    # idea via snap
    apt install snapd
    snap install skype --classic
    snap install intellij-idea-community --classic
fi
