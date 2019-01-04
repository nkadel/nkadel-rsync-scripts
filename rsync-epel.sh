#!/bin/sh
#
# epel-mirror.sh - mirror EPEL for mock use
# $Id: rsync-epel.sh,v 1.18 2012/08/05 11:20:19 root Exp root $

# Sort things correctly
export LANG=C

PROGNAME="$0"

RSYNCARGS="$@"

RSYNCARGS="$RSYNCARGS -aH"
RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -q"
RSYNCARGS="$RSYNCARGS --no-motd"
RSYNCARGS="$RSYNCARGS -P"

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

#RSYNCARGS="$RSYNCARGS --bwlimit=40"
#RSYNCARGS="$RSYNCARGS --dry-run"
RSYNCARGS="$RSYNCARGS --timeout=120"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"

EXCLUDES="--exclude-from=$PWD/rsync-epel.excludes"

cd /var/www/linux/epel || exit 1

num=0
while [ $num -lt 30 ]; do
    rsync $RSYNCARGS \
	  $EXCLUDES \
	  rsync://mirrors.kernel.org/fedora-epel/ ./ && break
    num=`expr $num + 1`
done

