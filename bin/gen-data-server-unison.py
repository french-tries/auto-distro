import os

import configuration

output = os.path.join("/home", configuration.username, ".unison", configuration.secondary_data_main + "-" + configuration.ssh_server_hostname + ".prf" )

with open(output, mode='w') as script:
    script.write('# Unison preferences\n\n')
    
    script.write(f'label = Sync sorted data in {configuration.secondary_data_main} dataset with {configuration.ssh_server_hostname}\n\n')
    
    for entry in configuration.data_shares:
        script.write(f'path = {entry}\n')
        
    script.write('\nignore = Name {.snapshots}\n\n')
    
    script.write(f'root = {configuration.data_full_path}\n')
    script.write(f'root = ssh://{configuration.ssh_server_hostname}/{configuration.server_data_mount}\n\n')

    script.write('sshargs = -C\n')
    
