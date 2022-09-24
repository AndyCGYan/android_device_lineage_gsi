#!/system/bin/sh

mkdir -p /mnt/phh
mount -t tmpfs -o rw,nodev,relatime,mode=755,gid=0 none /mnt/phh || true
mkdir /mnt/phh/empty_dir
touch /mnt/phh/empty_file
