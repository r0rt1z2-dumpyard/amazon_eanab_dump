#!/system/bin/sh
# Get additional kernel logs

LOG_DIR=/data/system/klogs
LAST_KMSG=$LOG_DIR/sys_last_kmsg
IOHW_LOG=/proc/iohwlog
randnum=$RANDOM
LOG_NAME=klog-wdog-$randnum
CONSOLE_LOG=/sys/fs/pstore/console-ramoops
FTRACE_LOG=/sys/fs/pstore/ftrace-ramoops-0

# get more logs and generate a tgz and save in /data/system/klogs
# the spectator log gets truncated. we want the full logs
get_watchdog_klogs()
{
    # if ftrace log does not exist, skip
    [ ! -e $FTRACE_LOG ] && return

    if cat /proc/life_cycle_reason | grep -iq "watchdog"; then
	mkdir -p $LOG_DIR/$LOG_NAME
	[ -e $CONSOLE_LOG ] && cp $CONSOLE_LOG $LOG_DIR/$LOG_NAME/
	cp $FTRACE_LOG $LOG_DIR/$LOG_NAME/
	[ -e $IOHW_LOG ] && cat $IOHW_LOG >> $LOG_DIR/$LOG_NAME/iohw.log
	[ -e $LAST_KMSG ] && cp $LAST_KMSG $LOG_DIR/$LOG_NAME/
	busybox tar zcf $LOG_DIR/$LOG_NAME.tgz -C $LOG_DIR $LOG_NAME
	rm -rf $LOG_DIR/$LOG_NAME
	sync
    fi
}

generate_LAST_KMSG()
{
    # No additional logs, just return
    [ ! -f $FTRACE_LOG ] && return

    rm -f $LAST_KMSG

    [ -e $CONSOLE_LOG ] && \
	cp $CONSOLE_LOG $LAST_KMSG

    chmod 0640 $LAST_KMSG

    [ -e $FTRACE_LOG ] && {
	echo "----------------------------------" >> $LAST_KMSG
	echo "FTRACE RAMOOPS " >> $LAST_KMSG
	echo "----------------------------------" >> $LAST_KMSG
	busybox tail -n 100 $FTRACE_LOG >> $LAST_KMSG
	echo "----------------------------------" >> $LAST_KMSG
	echo "FTRACE RAMOOPS END " >> $LAST_KMSG
	echo "----------------------------------" >> $LAST_KMSG
    }

    get_watchdog_klogs

    [ -e "$LOG_DIR/$LOG_NAME.tgz" ] && \
	echo "Full-Log: $LOG_DIR/$LOG_NAME.tgz" >> $LAST_KMSG

    sync
    setprop klog.done true
}

generate_LAST_KMSG
