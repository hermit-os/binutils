#
# Regular cron jobs for the binutils package
#
0 4	* * *	root	[ -x /usr/bin/binutils_maintenance ] && /usr/bin/binutils_maintenance
