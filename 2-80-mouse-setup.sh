#!/bin/bash

USER_NAME=`python3 bin/configuration.py username`
HOSTNAME=`python3 bin/configuration.py hostname`
DATA_MOUNT=`python3 bin/configuration.py data_mount`
DATA_PATH=`python3 bin/configuration.py data_path`

# copy paste via mouse buttons

cat >> /home/${USER_NAME}/.bashrc << \EOF

xbindkeys --poll-rc
EOF

cat >> /home/${USER_NAME}/.xbindkeysrc << \EOF

# Button 8 copies
"xte 'keydown Control_L' 'key c' ;keyup Control_L'" # Copy
b:8

# Button 9 copies
"xte 'keydown Control_L' 'key v' ;keyup Control_L'" # Paste
b:9
EOF
