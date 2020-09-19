

disk = "/dev/disk/by-id/DISK"

uefi_boot = False                   # True or False

boot_pool_name = "bpool"
root_pool_name = "rpool"

# Where grub is managed
primary_dataset_name = "PRIMSET"

system_dataset_name = "SYSSET"
user_dataset_name = "USERSET"
root_user_dataset_name = "ROOTSET"

debootstrap_suite = "buster"

network_interface = "enp3s0"

hostname = "HOSTNAME"
username = "USER"

popcon = True                       # True or False
primary_distro = False              # True or False
gpu_type = "amd"
minimal = False                     # True or False
work = True                         # True or False

ssh_server_port = 22
ssh_server_hostname = "SERVER"
ssh_server_username = "USER"
ssh_server_address = "0.0.0.0"

nfs_entries = [
#        [f'{ssh_server_address}:SERVER_PATH', 'SYSTEM_PATH'],
    ]

secondary_pool = "spool"
secondary_encrypted_path = "encr"
secondary_data_main = "data"

server_data_mount = "/SERVER/DATA/MOUNT/"
data_mount = f"/media/{hostname}/{secondary_pool}"

data_path = f"{secondary_encrypted_path}/{secondary_data_main}"
data_dataset = f"{secondary_pool}/{data_path}"

data_shares = [ "FOO", "BAR", "BAZ", "..." ]


if __name__ == "__main__":
    import argparse, sys

    parser = argparse.ArgumentParser(description='Get configuration values.')
    parser.add_argument('argument', help='the name of the value to return')

    args = parser.parse_args()
    
    if args.argument in globals():
        print(globals()[args.argument])
        sys.exit(0)
    else:
        sys.exit(1)
