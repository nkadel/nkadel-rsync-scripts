#!/bin/sh
#
# jpackage-mirror.sh - mirror JPackage
# $Id: rsync-jpackage.sh,v 1.13 2013/08/03 17:50:13 root Exp root $

# Sort things correctly
export LANG=C

PROGNAME="$0"

echo "$PROGNAME: disabled" >&2
exit 1

RSYNCARGS="$@"

RSYNCARGS="$RSYNCARGS -aH"
RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -q"
RSYNCARGS="$RSYNCARGS --no-motd"
RSYNCARGS="$RSYNCARGS -P"
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

#RSYNCARGS="$RSYNCARGS --bwlimit=20"
#RSYNCARGS="$RSYNCARGS --dry-run"
RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"

EXCLUDES="--exclude-from=$PWD/rsync-fedora.excludes"

cd /var/www/linux/jpackage || exit 1

# dotsrc is mucked up, try mirrorservice
num=0
while [ $num -lt 30 ]; do
    rsync $RSYNCARGS \
	  $EXCLUDES \
	  rsync://rsync.mirrorservice.org/jpackage.org/ ./ && break
    num=`expr $num + 1`
done

case "$RSYNCARGS" in
    *--dry-run*)
	echo Skipping hardlink with $@
	;;
    *)
	nice /usr/sbin/hardlink -v .
	;;
esac
