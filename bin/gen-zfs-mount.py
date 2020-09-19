import os

import configuration

output = '/usr/local/bin/data-mount.sh'

with open(output, mode='w') as script:
    script.write('#!/bin/sh\n\n')
    
    script.write(f'mkdir -p {configuration.data_mount}\n')
    script.write(f'zpool import -R {configuration.data_mount} {configuration.secondary_pool}\n\n')
    
    script.write(f'zfs load-key {os.path.join(configuration.secondary_pool, configuration.secondary_encrypted_path)}\n\n')
    
    script.write(f'zfs mount {configuration.data_dataset}\n')

    for entry in configuration.data_shares:
        script.write(f'zfs mount {os.path.join(configuration.data_dataset, entry)}\n')
    
