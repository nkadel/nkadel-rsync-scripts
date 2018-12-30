#!/bin/sh
#
# rsync-sl.sh - mirror scientific linux for mock use
# $Id: rsync-scientific.sh,v 1.16 2013/12/31 21:33:01 root Exp root $

#echo "Disabled"
#exit 1

# Sort things correctly
LANG=C

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
    *--delete*)
	echo Skipping --delete-after selection with $@
	;;
    *)
	#RSYNCARGS="$RSYNCARGS --delete"
	RSYNCARGS="$RSYNCARGS --delete-after"
	;;
esac

RSYNCARGS="$RSYNCARGS --delete-excluded"

RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --bwlimit=20"
#RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --dry-run"

EXCLUDES="==exclude-from=${PWD}/rsync-scientific.excludes"

cd /var/www/linux/scientific || \
    exit 1

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://rsync.scientificlinux.org/scientific/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://rsync.scientificlinux.org/scientific/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://rsync.scientificlinux.org/scientific/ ./

#case "$RSYNCARGS" in
#    *--dry-run*)
#	echo Skipping hardlink with $@
#	;;
#    *)
#	nice /usr/sbin/hardlink -v .
#	;;
#esac
