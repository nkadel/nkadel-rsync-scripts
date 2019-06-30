#!/bin/sh
#

echo $0 not currently enabled, exiting
exit 0

# rsync-sl-obsolete.sh - mirror scientific linux obsolete releases for mock use
# $Id: rsync-sl-obsolete.sh,v 1.4 2013/12/31 21:35:15 root Exp root $

# Sort things correctly
export LANG=C

PROGNAME="$0"

RSYNCARGS="$@"

RSYNCARGS="$RSYNCARGS -aH"
RSYNCARGS="$RSYNCARGS -v"
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
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --bwlimit=20"
#RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --dry-run"

EXCLUDES="--exclude-from=$PWD/rsync-sl-obsolete.excludes"

cd /var/www/linux/sl-obsolete || \
    exit 1

num=0
while [ $num -lt 30 ]; do
    rsync $RSYNCARGS \
	  $EXCLUDES \
	  rsync://ftp.scientificlinux.org/scientific/obsolete/ ./ && break
done

case "$RSYNCARGS" in
    *--dry-run*)
	echo Skipping hardlink with $@
	;;
    *)
	nice /usr/sbin/hardlink -v .
	;;
esac
