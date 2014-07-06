#!/bin/sh
#
# rsync-rhelr.sh - mirror Fedora
# $Id: rsync-rhel.sh,v 1.14 2012/07/01 03:02:29 root Exp root $

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

#RSYNCARGS="$RSYNCARGS --bwlimit=20"
#RSYNCARGS="$RSYNCARGS --dry-run"
RSYNCARGS="$RSYNCARGS --timeout=60"
RSYNCARGS="$RSYNCARGS --no-owner"
RSYNCARGS="$RSYNCARGS --no-group"

EXCLUDES="$EXCLUDES --exclude=SRPMS"
EXCLUDES="$EXCLUDES --exclude=source"
EXCLUDES="$EXCLUDES --exclude=ppc"
EXCLUDES="$EXCLUDES --exclude=ppc64"
EXCLUDES="$EXCLUDES --exclude=i386"
EXCLUDES="$EXCLUDES --exclude=i686"
EXCLUDES="$EXCLUDES --exclude=x86_64"
EXCLUDES="$EXCLUDES --exclude=s390"
EXCLUDES="$EXCLUDES --exclude=s390x"

EXCLUDES="$EXCLUDES --exclude=core"
#EXCLUDES="$EXCLUDES --exclude=development"
#EXCLUDES="$EXCLUDES --exclude=updates"
#EXCLUDES="$EXCLUDES --exclude=release"
EXCLUDES="$EXCLUDES --exclude=rawhide"
#EXCLUDES="$EXCLUDES --exclude=extras"
EXCLUDES="$EXCLUDES --exclude=debug"
EXCLUDES="$EXCLUDES --exclude=Debuginfo"

EXCLUDES="$EXCLUDES --exclude=CloudForms"
EXCLUDES="$EXCLUDES --exclude=JBEAP"
EXCLUDES="$EXCLUDES --exclude=JBEWS"
EXCLUDES="$EXCLUDES --exclude=JBWFK"
EXCLUDES="$EXCLUDES --exclude=RHCERT"
EXCLUDES="$EXCLUDES --exclude=RHDirServ"
EXCLUDES="$EXCLUDES --exclude=RHEIPA"
EXCLUDES="$EXCLUDES --exclude=RHEMRG"
EXCLUDES="$EXCLUDES --exclude=RHEMRG-RHEL6"
EXCLUDES="$EXCLUDES --exclude=RHEV"
EXCLUDES="$EXCLUDES --exclude=RHHC"
EXCLUDES="$EXCLUDES --exclude=RHNPROXY"
EXCLUDES="$EXCLUDES --exclude=RHNSAT"
EXCLUDES="$EXCLUDES --exclude=RHNTOOLS"
EXCLUDES="$EXCLUDES --exclude=RHOCS"
EXCLUDES="$EXCLUDES --exclude=RHS"
EXCLUDES="$EXCLUDES --exclude=RHUI"
EXCLUDES="$EXCLUDES --exclude=RHWAS"
EXCLUDES="$EXCLUDES --exclude=SAM"
EXCLUDES="$EXCLUDES --exclude=SJIS"
EXCLUDES="$EXCLUDES --exclude=SSA"


#EXCLUDES="$EXCLUDES --exclude=drpms"
EXCLUDES="$EXCLUDES --exclude=iso"
#EXCLUDES="$EXCLUDES --exclude=jigdo"
#EXCLUDES="$EXCLUDES --exclude=pxeboot"
#EXCLUDES="$EXCLUDES --exclude=repoview"
EXCLUDES="$EXCLUDES --exclude=src-zips"
EXCLUDES="$EXCLUDES --exclude=rhevm-*"
EXCLUDES="$EXCLUDES --exclude=spacewalk-java-*"

EXCLUDES="$EXCLUDES --exclude=beta"

EXCLUDES="$EXCLUDES --exclude=2.1AS"
EXCLUDES="$EXCLUDES --exclude=2.1AW"
EXCLUDES="$EXCLUDES --exclude=2.1ES"
EXCLUDES="$EXCLUDES --exclude=2.1WS"
EXCLUDES="$EXCLUDES --exclude=3"
EXCLUDES="$EXCLUDES --exclude=4"
EXCLUDES="$EXCLUDES --exclude=5Client"
#EXCLUDES="$EXCLUDES --exclude=5Client/en/os/"
EXCLUDES="$EXCLUDES --exclude=5Server"
#EXCLUDES="$EXCLUDES --exclude=5Server/en/os/"

EXCLUDES="$EXCLUDES --exclude=6/en/os/"
EXCLUDES="$EXCLUDES --exclude=6Client/"
#EXCLUDES="$EXCLUDES --exclude=6Client/en/os/"
EXCLUDES="$EXCLUDES --exclude=6ComputeNode/"
#EXCLUDES="$EXCLUDES --exclude=6ComputeNode/en/os/"
#EXCLUDES="$EXCLUDES --exclude=6Server/en/os/"
EXCLUDES="$EXCLUDES --exclude=6Workstation/"
#EXCLUDES="$EXCLUDES --exclude=6Workstation/en/os/"

# Don't really need these for fedora for now

cd /var/www/mirrors/redhat/enterprise/ || exit 1

#rsync $RSYNCARGS \
#    $EXCLUDES \
#    rsync://mirrors.kernel.org/redhat/redhat/linux/enterprise/ ./

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://rpmfind.net/linux/redhat/linux/enterprise/ ./

case "$RSYNCARGS" in
    *--dry-run*)
	echo Skipping hardlink with $@
	;;
    *)
	nice /usr/sbin/hardlink -v .
	;;
esac
