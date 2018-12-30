#!/bin/sh
#
# epel-mirror.sh - mirror EPEL for mock use
# $Id: rsync-epel.sh,v 1.18 2012/08/05 11:20:19 root Exp root $

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

#rsync $RSYNCARGS \
#    $EXCLUDES \
#    rsync://mirrors.kernel.org/fedora-epel/ ./

#rsync $RSYNCARGS \
#    $EXCLUDES \
#    rsync://mirrors.tummy.com/epel/ ./ || \

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora-epel/ ./

#case "$RSYNCARGS" in
#    *--dry-run*)
#	echo Skipping hardlink with $@
#	;;
#    *)
#	nice /usr/sbin/hardlink -v .
#	;;
#esac
