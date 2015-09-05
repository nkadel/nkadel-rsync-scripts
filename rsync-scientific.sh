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
RSYNCARGS="$RSYNCARGS --delay-updates"

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
#EXCLUDES="$EXCLUDES --exclude=SRPMS"
#EXCLUDES="$EXCLUDES --exclude=source"
EXCLUDES="$EXCLUDES --exclude=obsolete"

EXCLUDES="$EXCLUDES --exclude=fullfilelist"

EXCLUDES="$EXCLUDES --exclude=iso"
EXCLUDES="$EXCLUDES --exclude=*bin*.iso"
EXCLUDES="$EXCLUDES --exclude=*Install*.iso"
EXCLUDES="$EXCLUDES --exclude=*Live*.iso"
EXCLUDES="$EXCLUDES --exclude=LiveOS"
EXCLUDES="$EXCLUDES --exclude=livecd"
EXCLUDES="$EXCLUDES --exclude=headers"
EXCLUDES="$EXCLUDES --exclude=HEADER.html"

EXCLUDES="$EXCLUDES --exclude=devtoolset"

EXCLUDES="$EXCLUDES --exclude=ppc"
EXCLUDES="$EXCLUDES --exclude=alpha"
EXCLUDES="$EXCLUDES --exclude=ppc64"
EXCLUDES="$EXCLUDES --exclude=ia64"
EXCLUDES="$EXCLUDES --exclude=s390"
EXCLUDES="$EXCLUDES --exclude=s390x"
EXCLUDES="$EXCLUDES --exclude=i386"
#EXCLUDES="$EXCLUDES --exclude=x86_64"

# To bulky, not needed
EXCLUDES="$EXCLUDES --exclude=*rolling"

## Version 4 no longer supported
#EXCLUDES="$EXCLUDES --exclude=4x"
#EXCLUDES="$EXCLUDES --exclude=4x/SRPMS"

EXCLUDES="$EXCLUDES --exclude=5*/"
#EXCLUDES="$EXCLUDES --exclude=5"
EXCLUDES="$EXCLUDES --exclude=5rolling"
#EXCLUDES="$EXCLUDES --exclude=5rolling/SRPMS"
#EXCLUDES="$EXCLUDES --exclude=5rolling/testing/SRPMS"
##EXCLUDES="$EXCLUDES --exclude=5rolling/x86_64/contrib/SRPMS"
## Much too bulky of file, churns too much. Grab only as needed
#EXCLUDES="$EXCLUDES --exclude=5rolling/x86_64/os/images/*"
#EXCLUDES="$EXCLUDES --exclude=5rolling/x86_64/os/isolinux/*"
#EXCLUDES="$EXCLUDES --exclude=50"
#EXCLUDES="$EXCLUDES --exclude=51"
#EXCLUDES="$EXCLUDES --exclude=52"
#EXCLUDES="$EXCLUDES --exclude=53"
#EXCLUDES="$EXCLUDES --exclude=54"
#EXCLUDES="$EXCLUDES --exclude=55"
#EXCLUDES="$EXCLUDES --exclude=56"
#EXCLUDES="$EXCLUDES --exclude=57"
#EXCLUDES="$EXCLUDES --exclude=58"
#EXCLUDES="$EXCLUDES --exclude=59"
#EXCLUDES="$EXCLUDES --exclude=510"
##EXCLUDES="$EXCLUDES --exclude=510/SRPMS"
##EXCLUDES="$EXCLUDES --exclude=510/SRPMS/vendor"
##EXCLUDES="$EXCLUDES --exclude=510/x86_64/contrib/SRPMS"
#EXCLUDES="$EXCLUDES --exclude=5x"
##EXCLUDES="$EXCLUDES --exclude=5x/SRPMS"
##EXCLUDES="$EXCLUDES --exclude=5x/SRPMS/vendor"

#EXCLUDES="$EXCLUDES --exclude=6"
#EXCLUDES="$EXCLUDES --exclude=6/SRPMS"
EXCLUDES="$EXCLUDES --exclude=6.0"
EXCLUDES="$EXCLUDES --exclude=6.1"
EXCLUDES="$EXCLUDES --exclude=6.2"
EXCLUDES="$EXCLUDES --exclude=6.3"
EXCLUDES="$EXCLUDES --exclude=6.4"
EXCLUDES="$EXCLUDES --exclude=6.5"
EXCLUDES="$EXCLUDES --exclude=6.6"
#EXCLUDES="$EXCLUDES --exclude=6.7"
#EXCLUDES="$EXCLUDES --exclude=6.7/i386/os/images/*"
#EXCLUDES="$EXCLUDES --exclude=6.7/i386/os/isolinux/*"
EXCLUDES="$EXCLUDES --exclude=7.0"
#EXCLUDES="$EXCLUDES --exclude=7.1"
#EXCLUDES="$EXCLUDES --exclude=7.2"

# Actually symlink to 6x/SRPMS
##EXCLUDES="$EXCLUDES --exclude=6.7/SRPMS"
#EXCLUDES="$EXCLUDES --exclude=6x"
#EXCLUDES="$EXCLUDES --exclude=6x/SRPMS"
# /vendor is excluded separately
#EXCLUDES="$EXCLUDES --exclude=6x/SRPMS/vendor"
#EXCLUDES="$EXCLUDES --exclude=6rolling/SRPMS/vendor"

# Do keep rolling, it's useful for updates
#EXCLUDES="$EXCLUDES --exclude=6rolling"
# Much too bulky of file, churns too much. Grab only as needed
EXCLUDES="$EXCLUDES --exclude=6rolling/x86_64/os/images/*"
EXCLUDES="$EXCLUDES --exclude=6rolling/x86_64/os/isolinux/*"

EXCLUDES="$EXCLUDES --exclude=archive"
EXCLUDES="$EXCLUDES --exclude=archives"
EXCLUDES="$EXCLUDES --exclude=debuginfo"
EXCLUDES="$EXCLUDES --exclude=documents"
#EXCLUDES="$EXCLUDES --exclude=obsolete"
EXCLUDES="$EXCLUDES --exclude=virtual.images"
#EXCLUDES="$EXCLUDES --exclude=vendor"
#EXCLUDES="$EXCLUDES --exclude=*rolling"

EXCLUDES="$EXCLUDES --exclude=apt"
# libreoffice-langpack-en needed for desktops, not others, very bulky
# openoffice not needed, but openoffice-langpack-en is harmless
EXCLUDES="$EXCLUDES --exclude=*-langpack-[a-d]*rpm"
EXCLUDES="$EXCLUDES --exclude=*-langpack-e[a-mo-z]*rpm"
EXCLUDES="$EXCLUDES --exclude=*-langpack-[f-z]*rpm"


EXCLUDES="$EXCLUDES --exclude=kde-i18n-[a-zA-Z]*"
#EXCLUDES="$EXCLUDES --exclude=*xen*"
#EXCLUDES="$EXCLUDES --exclude=*PAE*"

cd /var/www/linux/scientific || \
    exit 1

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://rsync.gtlib.gatech.edu/scientific/ ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://rsync.gtlib.gatech.edu/scientific/ ./

#case "$RSYNCARGS" in
#    *--dry-run*)
#	echo Skipping hardlink with $@
#	;;
#    *)
#	nice /usr/sbin/hardlink -v .
#	;;
#esac
