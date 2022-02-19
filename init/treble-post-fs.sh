#!/system/bin/sh

mkdir -p /mnt/phh
mount -t tmpfs -o rw,nodev,relatime,mode=755,gid=0 none /mnt/phh || true
mkdir /mnt/phh/empty_dir
touch /mnt/phh/empty_file

copyprop() {
    p="$(getprop "$2")"
    if [ "$p" ]; then
        resetprop_sys "$1" "$(getprop "$2")"
    fi
}

if getprop ro.vendor.build.fingerprint | grep -qi -e iaomi/mona; then
    copyprop ro.product.manufacturer ro.product.vendor.manufacturer
fi
