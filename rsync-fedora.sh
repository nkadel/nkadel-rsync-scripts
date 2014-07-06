#!/bin/sh
#
# fedora-mirror.sh - mirror Fedora
# $Id: rsync-fedora.sh,v 1.20 2013/12/31 21:33:01 root Exp root $

LANG=C

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
#EXCLUDES="$EXCLUDES --exclude=x86_64"

#EXCLUDES="$EXCLUDES --exclude=updates"
#EXCLUDES="$EXCLUDES --exclude=releases"
EXCLUDES="$EXCLUDES --exclude=rawhide"
#EXCLUDES="$EXCLUDES --exclude=extras"
EXCLUDES="$EXCLUDES --exclude=debug"

#EXCLUDES="$EXCLUDES --exclude=*-langpack-*rpm"
EXCLUDES="$EXCLUDES --exclude=*-langpack-e[a-mo-z]-*rpm"
EXCLUDES="$EXCLUDES --exclude=*-langpack-[a-df-z]*rpm"

EXCLUDES="$EXCLUDES --exclude=Saaghar-*"
EXCLUDES="$EXCLUDES --exclude=alienarena*"
EXCLUDES="$EXCLUDES --exclude=amarok*"
EXCLUDES="$EXCLUDES --exclude=koffice-langpack-*rpm"
EXCLUDES="$EXCLUDES --exclude=tesseract-langpack-*rpm"

#EXCLUDES="$EXCLUDES --exclude=Everything"
#EXCLUDES="$EXCLUDES --exclude=Live"
EXCLUDES="$EXCLUDES --exclude=LiveOS"
#EXCLUDES="$EXCLUDES --exclude=jigdo"
EXCLUDES="$EXCLUDES --exclude=pxeboot"
EXCLUDES="$EXCLUDES --exclude=repoview"
EXCLUDES="$EXCLUDES --exclude=drpms"
EXCLUDES="$EXCLUDES --exclude=*.drpm"

#EXCLUDES="$EXCLUDES --exclude=iso"
EXCLUDES="$EXCLUDES --exclude=Fedora*DVD.iso"
#EXCLUDES="$EXCLUDES --exclude=Fedora*disc*.iso"
EXCLUDES="$EXCLUDES --exclude=Fedora*Live*.iso"

EXCLUDES="$EXCLUDES --exclude=7"
EXCLUDES="$EXCLUDES --exclude=8"
EXCLUDES="$EXCLUDES --exclude=9"
EXCLUDES="$EXCLUDES --exclude=10"
EXCLUDES="$EXCLUDES --exclude=11"
EXCLUDES="$EXCLUDES --exclude=12"
EXCLUDES="$EXCLUDES --exclude=13"
EXCLUDES="$EXCLUDES --exclude=13-Alpha"
EXCLUDES="$EXCLUDES --exclude=14"
EXCLUDES="$EXCLUDES --exclude=15"
EXCLUDES="$EXCLUDES --exclude=16"
EXCLUDES="$EXCLUDES --exclude=17"
EXCLUDES="$EXCLUDES --exclude=18"
EXCLUDES="$EXCLUDES --exclude=19"
EXCLUDES="$EXCLUDES --exclude=20"

EXCLUDES="$EXCLUDES --exclude=development"
EXCLUDES="$EXCLUDES --exclude=development/20"
EXCLUDES="$EXCLUDES --exclude=development/rawhide/"

# Music formatting
EXCLUDES="$EXCLUDES --exclude=lilypond-*.rpm"

# Games bloatware
EXCLUDES="$EXCLUDES --exclude=0ad*"
EXCLUDES="$EXCLUDES --exclude=FlightGear*.rpm"
EXCLUDES="$EXCLUDES --exclude=asterisk*.rpm"
EXCLUDES="$EXCLUDES --exclude=astromenace-*.rpm"
EXCLUDES="$EXCLUDES --exclude=beneath-a-steel-sky-*.rpm"
EXCLUDES="$EXCLUDES --exclude=berusky*.rpm"
EXCLUDES="$EXCLUDES --exclude=boswars*.rpm"
EXCLUDES="$EXCLUDES --exclude=btanks-*.rpm"
EXCLUDES="$EXCLUDES --exclude=ember-*.rpm"
EXCLUDES="$EXCLUDES --exclude=etoys-*.rpm"
EXCLUDES="$EXCLUDES --exclude=freedroidrpg-*.rpm"
EXCLUDES="$EXCLUDES --exclude=frozen-bubble-*.rpm"
EXCLUDES="$EXCLUDES --exclude=hedgewars-*.rpm"
EXCLUDES="$EXCLUDES --exclude=megaglest*"
EXCLUDES="$EXCLUDES --exclude=naev-*.rpm"
EXCLUDES="$EXCLUDES --exclude=nexuiz*.rpm"
EXCLUDES="$EXCLUDES --exclude=nexwiz*.rpm"
EXCLUDES="$EXCLUDES --exclude=openarena*.rpm"
EXCLUDES="$EXCLUDES --exclude=redeclipse*"
EXCLUDES="$EXCLUDES --exclude=scorch3d-*.rpm"
EXCLUDES="$EXCLUDES --exclude=speed-dreams*.rpm"
EXCLUDES="$EXCLUDES --exclude=stellarium*.rpm"
EXCLUDES="$EXCLUDES --exclude=supertux*.rpm"
EXCLUDES="$EXCLUDES --exclude=torcs-*.rpm"
EXCLUDES="$EXCLUDES --exclude=tremulous-*.rpm"
EXCLUDES="$EXCLUDES --exclude=vdrift*.rpm"
EXCLUDES="$EXCLUDES --exclude=vegastrike-*.rpm"
EXCLUDES="$EXCLUDES --exclude=warmux-*.rpm"
EXCLUDES="$EXCLUDES --exclude=warzone*.rpm"
EXCLUDES="$EXCLUDES --exclude=wesnoth-*.rpm"
EXCLUDES="$EXCLUDES --exclude=widelands-*.rpm"
EXCLUDES="$EXCLUDES --exclude=worminator-*.rpm"
EXCLUDES="$EXCLUDES --exclude=wormux-*.rpm"
EXCLUDES="$EXCLUDES --exclude=yofrankie-*.rpm"

# Bulky, amazingly useless and stupid bloatware
EXCLUDES="$EXCLUDES --exclude=cloudy-*.rpm"
EXCLUDES="$EXCLUDES --exclude=earth-and-moon-backgrounds-*.rpm"
EXCLUDES="$EXCLUDES --exclude=fluid-soundfont-*.rpm"
EXCLUDES="$EXCLUDES --exclude=kde*wallpaper*.rpm"
EXCLUDES="$EXCLUDES --exclude=kde-l10n-*.rpm"
EXCLUDES="$EXCLUDES --exclude=kdelibs-apidocs*.rpm"
EXCLUDES="$EXCLUDES --exclude=kicad-doc-*.rpm"
EXCLUDES="$EXCLUDES --exclude=maxima-*.rpm"
EXCLUDES="$EXCLUDES --exclude=mingw32-*.rpm"
EXCLUDES="$EXCLUDES --exclude=mrpt*.rpm"
EXCLUDES="$EXCLUDES --exclude=openscada-*.rpm"
EXCLUDES="$EXCLUDES --exclude=qt-doc*.rpm"
EXCLUDES="$EXCLUDES --exclude=texlive-texmf-doc-*.rpm"
EXCLUDES="$EXCLUDES --exclude=gimp-help-*"

# Don't really need these for fedora for now
#EXCLUDES="$EXCLUDES --exclude=test"
EXCLUDES="$EXCLUDES --exclude=releases/test/17-Alpha"
EXCLUDES="$EXCLUDES --exclude=releases/test/17-Beta"
EXCLUDES="$EXCLUDES --exclude=releases/test/18-Beta"
EXCLUDES="$EXCLUDES --exclude=releases/test/19-Alpha"
EXCLUDES="$EXCLUDES --exclude=releases/test/20-Alpha"
EXCLUDES="$EXCLUDES --exclude=releases/test/20-Beta"
EXCLUDES="$EXCLUDES --exclude=testing"
EXCLUDES="$EXCLUDES --exclude=root-doc*"

cd /var/www/mirrors/fedora || exit 1

#if [ ! -e releases/18 ]; then
#    mkdir releases/18
#    echo Mirroring development/18 to releases/18
#    /bin/cp -a -l -n development/18/. releases/18/.
#fi

rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora/  ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora/  ./ || \
rsync $RSYNCARGS \
    $EXCLUDES \
    rsync://mirrors.kernel.org/fedora/  ./

case "$RSYNCARGS" in
    *--dry-run*)
	echo Skipping hardlink with $@
	;;
    *)
	nice /usr/sbin/hardlink -v .
	;;
esac
