#!/bin/bash

# add sbin to path
cat >> /etc/profile.d/sbin.sh << \EOF
  PATH=$PATH:/usr/sbin/
EOF
