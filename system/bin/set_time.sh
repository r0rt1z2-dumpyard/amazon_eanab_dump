#!/system/bin/sh
#
# This script will set device time to build
# time during boot up in case build time is more then
# current device time
#

build_time=$(getprop ro.build.date.utc)

# Set epoch time of Sat Jan  1 00:00:00 GMT 2000
# if build time is not set
[ "$build_time" ] || build_time=946684806

[ "$(date -u +%s)" -lt $build_time ] && {
    log "Device time is old " $date
    date -u $build_time
    busybox hwclock -w
}
