#!/bin/sh
#
# fedora-mirror.sh - mirror Fedora
# $Id: rsync-fedora.sh,v 1.20 2013/12/31 21:33:01 root Exp root $

LANG=C
export LANG

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
	echo Skipping --delete-after --delete-excluded selection with $@
	;;
    *)
	#RSYNCARGS="$RSYNCARGS --delete"
	RSYNCARGS="$RSYNCARGS --delete-after"
	RSYNCARGS="$RSYNCARGS --delete-excluded"
	;;
esac

RSYNCARGS="$RSYNCARGS --bwlimit=1000"
#RSYNCARGS="$RSYNCARGS --dry-run"
RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"

EXCLUDES="--exclude-from=$PWD/rsync-fedora.excludes"

cd /var/www/linux/fedora || exit 1

#if [ ! -e releases/30 ]; then
#    mkdir releases/30
#    echo Mirroring development/30 to releases/30
#    /bin/cp -a -l -n development/30/. releases/30/.
#fi

while true; do
    rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora/  ./ && break
done
