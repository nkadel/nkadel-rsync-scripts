#!/bin/sh
#
# rsync-sl.sh - mirror scientific linux for mock use
# $Id: rsync-scientific.sh,v 1.16 2013/12/31 21:33:01 root Exp root $

# Sort things correctly
export LANG=C

PROGNAME="$0"

RSYNCARGS="$@"

RSYNCARGS="$RSYNCARGS -aH"
RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -q"
RSYNCARGS="$RSYNCARGS --no-motd"
RSYNCARGS="$RSYNCARGS -P"
# Wait until updaate is complete to write!
#RSYNCARGS="$RSYNCARGS --delay-updates"

case "$RSYNCARGS" in
    *--delete*|*--exclude*)
	echo Skipping --delete-excluded selection with $@
	;;
    *)
	#RSYNCARGS="$RSYNCARGS --delete"
	RSYNCARGS="$RSYNCARGS --delete-excluded"
	;;
esac

RSYNCARGS="$RSYNCARGS --delete-after"

RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --bwlimit=20"
#RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --dry-run"

EXCLUDES="--exclude-from=$PWD/rsync-ius.excludes"

cd /var/www/linux/ius/ || \
    exit 1

num=0
while [ $num -lt 30 ]; do
    rsync $RSYNCARGS \
	  $EXCLUDES \
	  rsync://dl.iuscommunity.org/ius/ ./ && break
    num=`expr $num + 1`
done
