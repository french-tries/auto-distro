import os

import configuration

output = os.path.join("/home", configuration.username, ".ssh", "config")

with open(output, mode='a') as script:
    script.write(f'\nHost {configuration.ssh_server_hostname}\n')
    
    script.write(f'\tHostname\t{configuration.ssh_server_address}\n')
    script.write(f'\tPort\t\t{configuration.ssh_server_port}\n')
    script.write(f'\tUser\t\t{configuration.ssh_server_username}\n')
    script.write(f'\tIdentityFile\t{os.path.join("/home", configuration.username, ".ssh", "keys", configuration.hostname + "-" + configuration.ssh_server_hostname + ".rsa")}\n')
