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

if getprop ro.vendor.build.fingerprint | grep -qi -e iaomi/mona -e iaomi/taoyao; then
    copyprop ro.product.manufacturer ro.product.vendor.manufacturer
fi

if [ -f /metadata/phh-secure ]; then
    copyprop ro.build.device ro.vendor.build.device
    copyprop ro.system.build.fingerprint ro.vendor.build.fingerprint
    copyprop ro.bootimage.build.fingerprint ro.vendor.build.fingerprint
    copyprop ro.build.fingerprint ro.vendor.build.fingerprint
    copyprop ro.build.device ro.vendor.product.device
    copyprop ro.product.system.device ro.vendor.product.device
    copyprop ro.product.device ro.vendor.product.device
    copyprop ro.product.system.device ro.product.vendor.device
    copyprop ro.product.device ro.product.vendor.device
    copyprop ro.product.system.name ro.vendor.product.name
    copyprop ro.product.name ro.vendor.product.name
    copyprop ro.product.system.name ro.product.vendor.device
    copyprop ro.product.name ro.product.vendor.device
    copyprop ro.system.product.brand ro.vendor.product.brand
    copyprop ro.product.brand ro.vendor.product.brand
    copyprop ro.product.system.model ro.vendor.product.model
    copyprop ro.product.model ro.vendor.product.model
    copyprop ro.product.system.model ro.product.vendor.model
    copyprop ro.product.model ro.product.vendor.model
    copyprop ro.build.product ro.vendor.product.model
    copyprop ro.build.product ro.product.vendor.model
    copyprop ro.system.product.manufacturer ro.vendor.product.manufacturer
    copyprop ro.product.manufacturer ro.vendor.product.manufacturer
    copyprop ro.system.product.manufacturer ro.product.vendor.manufacturer
    copyprop ro.product.manufacturer ro.product.vendor.manufacturer
    (getprop ro.vendor.build.security_patch; getprop ro.keymaster.xxx.security_patch) | sort | tail -n 1 | while read v; do
        [ -n "$v" ] && resetprop_sys ro.build.version.security_patch "$v"
    done

    resetprop_sys ro.build.tags release-keys
    resetprop_sys ro.boot.vbmeta.device_state locked
    resetprop_sys ro.boot.verifiedbootstate green
    resetprop_sys ro.boot.flash.locked 1
    resetprop_sys ro.boot.veritymode enforcing
    resetprop_sys ro.boot.warranty_bit 0
    resetprop_sys ro.warranty_bit 0
    resetprop_sys ro.secure 1
    resetprop_sys ro.build.type user
    resetprop_sys ro.build.selinux 0
fi
