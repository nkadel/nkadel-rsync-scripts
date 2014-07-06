#!/bin/sh
#
# plf-mirros.sh - mirror Penguin Liberation Front contents
# $Id: rsync-plf.sh,v 1.10 2012/07/01 03:02:29 root Exp root $

PROGNAME="$0"

RSYNCARGS="$@"

RSYNCARGS="$RSYNCARGS -aH"
RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -v"
#RSYNCARGS="$RSYNCARGS -q"
RSYNCARGS="$RSYNCARGS --no-motd"
RSYNCARGS="$RSYNCARGS -P"
RSYNCARGS="$RSYNCARGS --ipv4"

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
   
#EXCLUDES="$EXCLUDES --exclude source"
EXCLUDES="$EXCLUDES --exclude binary"
EXCLUDES="$EXCLUDES --exclude debug"
EXCLUDES="$EXCLUDES --exclude media_info"
EXCLUDES="$EXCLUDES --exclude repoview"


EXCLUDES="$EXCLUDES --exclude i586"
EXCLUDES="$EXCLUDES --exclude amd64"
EXCLUDES="$EXCLUDES --exclude ppc"
EXCLUDES="$EXCLUDES --exclude x86_64"
EXCLUDES="$EXCLUDES --exclude noarch"

# Excessive, unnecessary targets
EXCLUDES="$EXCLUDES --exclude unity/"
EXCLUDES="$EXCLUDES --exclude mandrake"
EXCLUDES="$EXCLUDES --exclude mandriva/community"

# Targets for material hardlinked to main repo
# or out of date releases
EXCLUDES="$EXCLUDES --exclude mandriva/2005"
EXCLUDES="$EXCLUDES --exclude mandriva/2006.0"
EXCLUDES="$EXCLUDES --exclude mandriva/2006.1"
EXCLUDES="$EXCLUDES --exclude mandriva/2007.0"
EXCLUDES="$EXCLUDES --exclude mandriva/2007.1"
EXCLUDES="$EXCLUDES --exclude mandriva/2008.0"
EXCLUDES="$EXCLUDES --exclude mandriva/2008.1"
EXCLUDES="$EXCLUDES --exclude mandriva/2009.0"
EXCLUDES="$EXCLUDES --exclude mandriva/2009.1"
EXCLUDES="$EXCLUDES --exclude mandriva/2010.0"
EXCLUDES="$EXCLUDES --exclude mandriva/2010.1"
EXCLUDES="$EXCLUDES --exclude mandriva/2010.2"

EXCLUDES="$EXCLUDES --exclude mandriva/cfg"
EXCLUDES="$EXCLUDES --exclude mandriva/free"
EXCLUDES="$EXCLUDES --exclude mandriva/non-free"

cd /var/www/mirrors/plf || exit 1

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/plf/ ./

case "$RSYNCARGS" in
    *--dry-run*)
	echo Skipping hardlink with $@
	;;
    *)
	nice /usr/sbin/hardlink -v .
	;;
esac
