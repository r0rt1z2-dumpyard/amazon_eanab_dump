#!/system/bin/sh
PATH=/sbin:/system/sbin:/system/bin:/system/xbin

# FACTORYMODE file
factorymode="/data/system/FACTORYMODE"

build_tags=$(getprop ro.build.tags)
ret=none

if [[ $build_tags == *release-keys* ]]; then
    log -t FOSFLAGS "User build"
    ret=closed
fi

if [ -f $factorymode ]; then
    log -t FOSFLAGS "Device in factory mode"
    ret=none
fi

if [ $ret == closed ]; then
    log -t FOSFLAGS "Unset adb from persist.sys.usb.config property"
fi

echo $ret
