#!/bin/sh
#
# plf-mirros.sh - mirror Penguin Liberation Front contents
# $Id: rsync-plf.sh,v 1.10 2012/07/01 03:02:29 root Exp root $

# Sort things correctly
export LANG=C

PROGNAME="$0"

echo "PROGNAME: disabled" >&2
exit 1

RSYNCARGS="$@"

RSYNCARGS="$RSYNCARGS -aH"
RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -q"
RSYNCARGS="$RSYNCARGS --no-motd"
RSYNCARGS="$RSYNCARGS -P"
RSYNCARGS="$RSYNCARGS --ipv4"

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
   
EXCLUDES="--exclude-from=$PWD/rsync-plf.excludes"

cd /var/www/linux/plf || exit 1

num=0
while [ $num -lt 30 ]; do
    rsync $RSYNCARGS \
	  $EXCLUDES \
	  rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/plf/ ./ && break
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
