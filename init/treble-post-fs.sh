#!/system/bin/sh

copyprop() {
    p="$(getprop "$2")"
    if [ "$p" ]; then
        resetprop_sys "$1" "$(getprop "$2")"
    fi
}

mount -o bind /mnt/phh/empty_dir /vendor/app/Honeywell_SoftBox
mount -o bind /mnt/phh/empty_dir /vendor/app/ModemSettings

# Redirect vendor props for QCOM hwcomposer
setprop debug.phh.props.omposer-service vendor

# Override media volume steps
resetprop_sys ro.config.media_vol_steps 25
resetprop_sys ro.config.media_vol_default 8
