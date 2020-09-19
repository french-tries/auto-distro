import os

import configuration

output = '/etc/fstab'

with open(output, mode='a') as fstab:
    fstab.write('\n\n')
    for entry in configuration.nfs_entries:
        os.makedirs(entry[1], exist_ok=True)
        fstab.write(entry[0].ljust(50) + entry[1].ljust(40) + 'nfs'.ljust(10) + 'noauto'.ljust(30) + '0 0\n')
    
