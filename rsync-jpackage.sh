#!/bin/sh
#
# jpackage-mirror.sh - mirror JPackage
# $Id: rsync-jpackage.sh,v 1.13 2013/08/03 17:50:13 root Exp root $

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
    *--delete*)
	echo Skipping --delete-after selection with $@
	;;
    *)
	#RSYNCARGS="$RSYNCARGS --delete"
	RSYNCARGS="$RSYNCARGS --delete-after"
	;;
esac
RSYNCARGS="$RSYNCARGS --delete-excluded"

#RSYNCARGS="$RSYNCARGS --bwlimit=20"
#RSYNCARGS="$RSYNCARGS --dry-run"
RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"

EXCLUDES="$EXCLUDES --exclude=fullfilelist"

EXCLUDES="$EXCLUDES --exclude=1.0"
EXCLUDES="$EXCLUDES --exclude=1.5"
EXCLUDES="$EXCLUDES --exclude=1.6"
EXCLUDES="$EXCLUDES --exclude=1.7"
EXCLUDES="$EXCLUDES --exclude=3"
# 5.0 is newer
EXCLUDES="$EXCLUDES --exclude=5.0-beta"
EXCLUDES="$EXCLUDES --exclude=5.0"
EXCLUDES="$EXCLUDES --exclude=5.0-updates"

#EXCLUDES="$EXCLUDES --exclude=6.0"

#EXCLUDES="$EXCLUDES --exclude=*.gz"
#EXCLUDES="$EXCLUDES --exclude=*.cz"

# Irritating and confusing symlinks
EXCLUDES="$EXCLUDES --exclude=*RPMS.devel"
EXCLUDES="$EXCLUDES --exclude=*RPMS.free"
EXCLUDES="$EXCLUDES --exclude=*RPMS.non-free"

#EXCLUDES="$EXCLUDES --exclude=SRPMS"

EXCLUDES="$EXCLUDES --exclude=base"
#EXCLUDES="$EXCLUDES --exclude=devel"
EXCLUDES="$EXCLUDES --exclude=fedora-18"
EXCLUDES="$EXCLUDES --exclude=fedora-17"
EXCLUDES="$EXCLUDES --exclude=fedora-16"
EXCLUDES="$EXCLUDES --exclude=fedora-15"
EXCLUDES="$EXCLUDES --exclude=fedora-14"
EXCLUDES="$EXCLUDES --exclude=fedora-13"
EXCLUDES="$EXCLUDES --exclude=fedora-12"
EXCLUDES="$EXCLUDES --exclude=fedora-11"
EXCLUDES="$EXCLUDES --exclude=fedora-10"
EXCLUDES="$EXCLUDES --exclude=fedora-9"
EXCLUDES="$EXCLUDES --exclude=fedora-8"
EXCLUDES="$EXCLUDES --exclude=fedora-7"
EXCLUDES="$EXCLUDES --exclude=fedora-6"
EXCLUDES="$EXCLUDES --exclude=fedora-5"
EXCLUDES="$EXCLUDES --exclude=fedora-4"
EXCLUDES="$EXCLUDES --exclude=fedora-3"
EXCLUDES="$EXCLUDES --exclude=fedora-2"
EXCLUDES="$EXCLUDES --exclude=fedora-1"
EXCLUDES="$EXCLUDES --exclude=redhat-9"
EXCLUDES="$EXCLUDES --exclude=suse-es-8.0"
EXCLUDES="$EXCLUDES --exclude=suse-es-9.0"
EXCLUDES="$EXCLUDES --exclude=redhat-8.0"
EXCLUDES="$EXCLUDES --exclude=redhat-7.3"
EXCLUDES="$EXCLUDES --exclude=redhat-7.2"
#EXCLUDES="$EXCLUDES --exclude=redhat-el-6.0"
EXCLUDES="$EXCLUDES --exclude=redhat-el-5.0"
EXCLUDES="$EXCLUDES --exclude=redhat-el-4.0"
EXCLUDES="$EXCLUDES --exclude=redhat-el-3.0"
EXCLUDES="$EXCLUDES --exclude=redhat-el-2.1"
EXCLUDES="$EXCLUDES --exclude=mandrake-10.1"
EXCLUDES="$EXCLUDES --exclude=mandrake-10.0"
EXCLUDES="$EXCLUDES --exclude=mandrake-9.2"
EXCLUDES="$EXCLUDES --exclude=mandrake-9.1"
EXCLUDES="$EXCLUDES --exclude=hdlist.cz"
EXCLUDES="$EXCLUDES --exclude=headers"
EXCLUDES="$EXCLUDES --exclude=list"
EXCLUDES="$EXCLUDES --exclude=repoview"
EXCLUDES="$EXCLUDES --exclude=media_info"
EXCLUDES="$EXCLUDES --exclude=hdlist.cz"
EXCLUDES="$EXCLUDES --exclude=synthesis.hdlist.cz"

# Bulky idiot tool
EXCLUDES="$EXCLUDES --exclude=scalate-*"

# Generate these otherwise
#EXCLUDES="$EXCLUDES --exclude=repodata"

cd /var/www/linux/jpackage || exit 1

#rsync $RSYNCARGS \
#    $EXCLUDES \
#    rsync://mirrors.dotsrc.org/jpackage/ ./

# dotsrc is mucked up, try mirrorservice
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://rsync.mirrorservice.org/jpackage.org/ ./

case "$RSYNCARGS" in
    *--dry-run*)
	echo Skipping hardlink with $@
	;;
    *)
	nice /usr/sbin/hardlink -v .
	;;
esac
