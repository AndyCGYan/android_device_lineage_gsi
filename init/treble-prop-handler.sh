#!/system/bin/sh
set -o pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: ./treble-prop-handler.sh [prop]"
    exit 1
fi

prop_value=$(getprop "$1")

restartAudio() {
    setprop ctl.restart audioserver
    audioHal="$(getprop | sed -nE 's/.*init\.svc\.(.*audio-hal[^]]*).*/\1/p')"
    setprop ctl.restart "$audioHal"
    setprop ctl.restart vendor.audio-hal-2-0
    setprop ctl.restart audio-hal-2-0
}

if [ "$1" == "persist.sys.treble.caf.audio_policy" ]; then
    if [[ "$prop_value" != "true" && "$prop_value" != "false" ]]; then
        exit 1
    fi

    sku="$(getprop ro.boot.product.vendor.sku)"
    if [[ "$prop_value" == "true" ]]; then
        umount /vendor/etc/audio
        umount /vendor/etc/audio
        if [ -f /vendor/etc/audio_policy_configuration_sec.xml ]; then
            mount /vendor/etc/audio_policy_configuration_sec.xml /vendor/etc/audio_policy_configuration.xml
        elif [ -f /vendor/etc/audio/sku_${sku}_qssi/audio_policy_configuration.xml ] && [ -f /vendor/etc/audio/sku_$sku/audio_policy_configuration.xml ]; then
            umount /vendor/etc/audio
            mount /vendor/etc/audio/sku_${sku}_qssi/audio_policy_configuration.xml /vendor/etc/audio/sku_$sku/audio_policy_configuration.xml
        elif [ -f /vendor/etc/audio/audio_policy_configuration.xml ]; then
            mount /vendor/etc/audio/audio_policy_configuration.xml /vendor/etc/audio_policy_configuration.xml
        elif [ -f /vendor/etc/audio_policy_configuration_base.xml ]; then
            mount /vendor/etc/audio_policy_configuration_base.xml /vendor/etc/audio_policy_configuration.xml
        fi
    else
        umount /vendor/etc/audio_policy_configuration.xml
        umount /vendor/etc/audio/sku_$sku/audio_policy_configuration.xml
        umount /vendor/etc/a2dp_audio_policy_configuration.xml
        if [ $(find /vendor/etc/audio -type f |wc -l) -le 3 ];then
            mount /mnt/phh/empty_dir /vendor/etc/audio
        fi
    fi
    restartAudio
    exit
fi

if [ "$1" == "persist.sys.treble.caf.disable_soundvolume_effect" ];then
    if [[ "$prop_value" != "true" && "$prop_value" != "false" ]]; then
        exit 1
    fi

    if [[ "$prop_value" == "true" ]];then
        mount /mnt/phh/empty_file /vendor/lib/soundfx/libvolumelistener.so
        mount /mnt/phh/empty_file /vendor/lib64/soundfx/libvolumelistener.so
    else
        umount /vendor/lib/soundfx/libvolumelistener.so
        umount /vendor/lib64/soundfx/libvolumelistener.so
    fi
    restartAudio
    exit
fi

if [ "$1" == "persist.sys.treble.backlight_scale" ];then
    if [[ "$prop_value" != "true" && "$prop_value" != "false" ]]; then
        exit 1
    fi

    if [[ "$prop_value" == "true" ]]; then
        if [ -f /sys/class/leds/lcd-backlight/max_brightness ]; then
            setprop persist.sys.treble.backlight_scale.value "$(cat /sys/class/leds/lcd-backlight/max_brightness)"
        elif [ -f /sys/class/backlight/panel0-backlight/max_brightness ]; then
            setprop persist.sys.treble.backlight_scale.value "$(cat /sys/class/backlight/panel0-backlight/max_brightness)"
        fi
    else
        setprop persist.sys.treble.backlight_scale.value -1
    fi
    exit
fi
