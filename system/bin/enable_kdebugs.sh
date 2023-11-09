#!/system/bin/sh
# Enable runtime kernel debug options

LOG_DIR=/data/system/klogs

turn_on_debugs()
{
    # if /data/system/klogs/.debugon.ftrace exists, turn on pstore/ftrace
    [ -f "$LOG_DIR/.debugon.ftrace" ] && {
	[ -f "/sys/kernel/debug/pstore/record_ftrace" ] &&
	    echo 1 > /sys/kernel/debug/pstore/record_ftrace
    }
}

turn_on_debugs

return 0
