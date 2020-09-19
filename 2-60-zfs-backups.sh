#!/bin/bash

USER_NAME=`python3 bin/configuration.py username`
DATA_DATASET=`python3 bin/configuration.py data_dataset`
ROOT_POOL_NAME=`python3 bin/configuration.py root_pool_name`
SYSTEM_DATASET_NAME=`python3 bin/configuration.py system_dataset_name`
USER_DATASET_NAME=`python3 bin/configuration.py user_dataset_name`

apt install --yes debhelper libcapture-tiny-perl libconfig-inifiles-perl pv lzop mbuffer

mkdir -p /home/${USER_NAME}/git
pushd /home/${USER_NAME}/git

git clone https://github.com/jimsalterjrs/sanoid.git

cd sanoid
git checkout $(git tag | grep "^v" | tail -n 1)
ln -s packages/debian .
dpkg-buildpackage -uc -us
apt install ../sanoid_*_all.deb

#enable and start the sanoid timer
sudo systemctl enable sanoid.timer
sudo systemctl start sanoid.timer

popd

sed "s;%%DATA_DATASET%%;${DATA_DATASET};g;s;%%ROOT_DATASET%%;${ROOT_POOL_NAME}/ROOT/${SYSTEM_DATASET_NAME};g;s;%%USER_DATASET%%;${ROOT_POOL_NAME}/USERDATA/${USER_DATASET_NAME};g" \
etc/sanoid.conf > /etc/sanoid/sanoid.conf
