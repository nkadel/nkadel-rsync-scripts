#!/bin/sh
#

echo $0 not currently enabled, exiting
exit 0

# rsync-sl-obsolete.sh - mirror scientific linux obsolete releases for mock use
# $Id: rsync-sl-obsolete.sh,v 1.4 2013/12/31 21:35:15 root Exp root $

# Sort things correctly
LANG=C

PROGNAME="$0"

RSYNCARGS="$@"

RSYNCARGS="$RSYNCARGS -aH"
RSYNCARGS="$RSYNCARGS -v"
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

RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --bwlimit=20"
#RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"
#RSYNCARGS="$RSYNCARGS --dry-run"

EXCLUDES="$EXCLUDES --exclude=repoview"
#EXCLUDES="$EXCLUDES --exclude=source"

EXCLUDES="$EXCLUDES --exclude=SRPMS"
EXCLUDES="$EXCLUDES --exclude=debuginfo"
EXCLUDES="$EXCLUDES --exclude=testing"
EXCLUDES="$EXCLUDES --exclude=errata"
EXCLUDES="$EXCLUDES --exclude=build"
EXCLUDES="$EXCLUDES --exclude=base"

EXCLUDES="$EXCLUDES --exclude=archive"
EXCLUDES="$EXCLUDES --exclude=obsolete"

EXCLUDES="$EXCLUDES --exclude=iso"
EXCLUDES="$EXCLUDES --exclude=*bin*.iso"
EXCLUDES="$EXCLUDES --exclude=*Install*.iso"
EXCLUDES="$EXCLUDES --exclude=*Live*.iso"
EXCLUDES="$EXCLUDES --exclude=livecd"
EXCLUDES="$EXCLUDES --exclude=headers"
EXCLUDES="$EXCLUDES --exclude=HEADER.html"

EXCLUDES="$EXCLUDES --exclude=ppc"
EXCLUDES="$EXCLUDES --exclude=alpha"
EXCLUDES="$EXCLUDES --exclude=ppc64"
EXCLUDES="$EXCLUDES --exclude=ia64"
EXCLUDES="$EXCLUDES --exclude=s390"
EXCLUDES="$EXCLUDES --exclude=s390x"
EXCLUDES="$EXCLUDES --exclude=i386"
#EXCLUDES="$EXCLUDES --exclude=x86_64"

EXCLUDES="$EXCLUDES --exclude=301"
EXCLUDES="$EXCLUDES --exclude=302"
EXCLUDES="$EXCLUDES --exclude=303"
EXCLUDES="$EXCLUDES --exclude=304"
EXCLUDES="$EXCLUDES --exclude=305"
EXCLUDES="$EXCLUDES --exclude=306"
EXCLUDES="$EXCLUDES --exclude=307"
EXCLUDES="$EXCLUDES --exclude=308"
EXCLUDES="$EXCLUDES --exclude=309"
EXCLUDES="$EXCLUDES --exclude=30rolling.old"
EXCLUDES="$EXCLUDES --exclude=30rolling"
EXCLUDES="$EXCLUDES --exclude=30x"

EXCLUDES="$EXCLUDES --exclude=40"
EXCLUDES="$EXCLUDES --exclude=41"
EXCLUDES="$EXCLUDES --exclude=42"
EXCLUDES="$EXCLUDES --exclude=43"
EXCLUDES="$EXCLUDES --exclude=44"
EXCLUDES="$EXCLUDES --exclude=45"
EXCLUDES="$EXCLUDES --exclude=46"
EXCLUDES="$EXCLUDES --exclude=47"
EXCLUDES="$EXCLUDES --exclude=48"
#EXCLUDES="$EXCLUDES --exclude=49"
EXCLUDES="$EXCLUDES --exclude=49/SRPMS"
#EXCLUDES="$EXCLUDES --exclude=49/i386/apt/*"
#EXCLUDES="$EXCLUDES --exclude=49/i386/contrib"
#EXCLUDES="$EXCLUDES --exclude=49/i386/contrib/SRPMS"
#EXCLUDES="$EXCLUDES --exclude=49/i386/errata/SL/notdoneyet"
#EXCLUDES="$EXCLUDES --exclude=49/i386/sites"
#EXCLUDES="$EXCLUDES --exclude=49/i386/sites/example/SRPMS"
EXCLUDES="$EXCLUDES --exclude=49/x86_64/apt/*"
EXCLUDES="$EXCLUDES --exclude=49/x86_64/contrib"
#EXCLUDES="$EXCLUDES --exclude=49/x86_64/contrib/SRPMS"
EXCLUDES="$EXCLUDES --exclude=49/x86_64/errata/SL/notdoneyet"
EXCLUDES="$EXCLUDES --exclude=49/x86_64/sites"
#EXCLUDES="$EXCLUDES --exclude=49/x86_64/sites/example/SRPMS"


EXCLUDES="$EXCLUDES --exclude=apt"
EXCLUDES="$EXCLUDES --exclude=*-langpack-*rpm"
EXCLUDES="$EXCLUDES --exclude=kde-i18n-[a-zA-Z]*"
#EXCLUDES="$EXCLUDES --exclude=*xen*"
#EXCLUDES="$EXCLUDES --exclude=*PAE*"

cd /var/www/mirrors/sl-obsolete || \
    exit 1

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://ftp.scientificlinux.org/scientific/obsolete/ ./

case "$RSYNCARGS" in
    *--dry-run*)
	echo Skipping hardlink with $@
	;;
    *)
	nice /usr/sbin/hardlink -v .
	;;
esac
