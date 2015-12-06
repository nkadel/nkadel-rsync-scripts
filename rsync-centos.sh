#!/bin/sh
#
# rsync-sl.sh - mirror scientific linux for mock use
# $Id: rsync-scientific.sh,v 1.16 2013/12/31 21:33:01 root Exp root $

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

EXCLUDES="$EXCLUDES --exclude=SRPMS"
EXCLUDES="$EXCLUDES --exclude=drpms"
EXCLUDES="$EXCLUDES --exclude=obsolete"
EXCLUDES="$EXCLUDES --exclude=repoview"
#EXCLUDES="$EXCLUDES --exclude=source"

EXCLUDES="$EXCLUDES --exclude=iso"
EXCLUDES="$EXCLUDES --exclude=isos"
#EXCLUDES="$EXCLUDES --exclude=*bin*.iso"
#EXCLUDES="$EXCLUDES --exclude=*Install*.iso"
#EXCLUDES="$EXCLUDES --exclude=*Live*.iso"
#EXCLUDES="$EXCLUDES --exclude=*minimal*.iso"
#EXCLUDES="$EXCLUDES --exclude=*DVD*.iso"
#EXCLUDES="$EXCLUDES --exclude=*Minimal*.iso"
#EXCLUDES="$EXCLUDES --exclude=*Everything*.iso"

EXCLUDES="$EXCLUDES --exclude=LiveOS"
EXCLUDES="$EXCLUDES --exclude=livecd"
EXCLUDES="$EXCLUDES --exclude=headers"
EXCLUDES="$EXCLUDES --exclude=HEADER.html"

EXCLUDES="$EXCLUDES --exclude=5*/"
EXCLUDES="$EXCLUDES --exclude=5"

EXCLUDES="$EXCLUDES --exclude=fullfilelist"

EXCLUDES="$EXCLUDES --exclude=virt"
EXCLUDES="$EXCLUDES --exclude=xen"
EXCLUDES="$EXCLUDES --exclude=xen4"

EXCLUDES="$EXCLUDES --exclude=i386"
EXCLUDES="$EXCLUDES --exclude=atomic"
#EXCLUDES="$EXCLUDES --exclude=x86_64"

# To bulky, not needed
EXCLUDES="$EXCLUDES --exclude=*rolling"

#EXCLUDES="$EXCLUDES --exclude=6"
#EXCLUDES="$EXCLUDES --exclude=6/SRPMS"

# libreoffice-langpack-en needed for desktops, not others, very bulky
# openoffice not needed, but openoffice-langpack-en is harmless
EXCLUDES="$EXCLUDES --exclude=*-langpack-[a-d]*rpm"
EXCLUDES="$EXCLUDES --exclude=*-langpack-e[a-mo-z]*rpm"
EXCLUDES="$EXCLUDES --exclude=*-langpack-[f-z]*rpm"

cd /var/www/linux/centos/ || \
    exit 1

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/centos/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/centos/ ./

#case "$RSYNCARGS" in
#    *--dry-run*)
#	echo Skipping hardlink with $@
#	;;
#    *)
#	nice /usr/sbin/hardlink -v .
#	;;
#esac
