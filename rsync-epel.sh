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

EXCLUDES="$EXCLUDES --exclude=SRPMS"
EXCLUDES="$EXCLUDES --exclude=source"
EXCLUDES="$EXCLUDES --exclude=csgfs"
EXCLUDES="$EXCLUDES --exclude=apt"
EXCLUDES="$EXCLUDES --exclude=docs"

EXCLUDES="$EXCLUDES --exclude=fullfilelist"

EXCLUDES="$EXCLUDES --exclude=isos"

EXCLUDES="$EXCLUDES --exclude=ppc"
EXCLUDES="$EXCLUDES --exclude=alpha"
EXCLUDES="$EXCLUDES --exclude=ppc64"
EXCLUDES="$EXCLUDES --exclude=ia64"
EXCLUDES="$EXCLUDES --exclude=s390"
EXCLUDES="$EXCLUDES --exclude=s390x"
EXCLUDES="$EXCLUDES --exclude=i386"
#EXCLUDES="$EXCLUDES --exclude=x86_64"

EXCLUDES="$EXCLUDES --exclude=debug"
EXCLUDES="$EXCLUDES --exclude=testing"

EXCLUDES="$EXCLUDES --exclude=4/"
EXCLUDES="$EXCLUDES --exclude=4AS"
EXCLUDES="$EXCLUDES --exclude=4ES"
EXCLUDES="$EXCLUDES --exclude=4WS"

EXCLUDES="$EXCLUDES --exclude=5Client"
EXCLUDES="$EXCLUDES --exclude=5Server"
EXCLUDES="$EXCLUDES --exclude=5/"
EXCLUDES="$EXCLUDES --exclude=repoview"

# beta/6 is no longer necessary
EXCLUDES="$EXCLUDES --exclude=beta/6"
# Eeeewww
EXCLUDES="$EXCLUDES --exclude=beta/7"

# Bulky and undesirable widgets
EXCLUDES="$EXCLUDES --exclude=asterisk*"
EXCLUDES="$EXCLUDES --exclude=clamav*"
EXCLUDES="$EXCLUDES --exclude=cloudy-*"
EXCLUDES="$EXCLUDES --exclude=mingw32-*"
EXCLUDES="$EXCLUDES --exclude=naev*"
EXCLUDES="$EXCLUDES --exclude=nexuiz*"
EXCLUDES="$EXCLUDES --exclude=nexwiz*"
EXCLUDES="$EXCLUDES --exclude=openscada*"
EXCLUDES="$EXCLUDES --exclude=refmac-*"
EXCLUDES="$EXCLUDES --exclude=root-doc*"
EXCLUDES="$EXCLUDES --exclude=vtk*"

# Excessive version changing, unnecessary software
EXCLUDES="$EXCLUDES --exclude=R-core*"
EXCLUDES="$EXCLUDES --exclude=octave-*"

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
