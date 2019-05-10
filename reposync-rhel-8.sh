#!/bin/sh
#
# reposync-rhel-6.sh - reposync RHEL rpms or SRPM's
#    Requires registration of RHEL channels
#
# License: GPL
# Author: Nico Kadel-Garcia <nkadel@gmail.com>

# Sort things correctly
export LANG=C

progname=`basename $0`

set -e

RSYNCARGS="$@"

REPODIR=/var/www/linux/reposync/rhel/8/

LOGFILE=/var/log/reposync/${progname}.log
rm -f $LOGFILE && \
    cat /dev/null >$LOGFILE || exit 1

# Exit on failures to pipes
set -o pipefail

REPOSYNCARGS=""
#REPOSYNCARGS="$REPOSYNCARGS --newest"
# Clean up after old package failures
REPOSYNCARGS="$REPOSYNCARGS --delete"

#REPOS=""
#REPOS="$REPOS rhel-8-for-x86_64-baseos-rpms"
#REPOS="$REPOS rhel-8-for-x86_64-appstream-rpms"
# Deduce subscribed repos. Repos are not even listed if not *subscribed*!!!
# "dnf repolist" contans undesired headers
REPOS="`dnf -q repolist --disablerepo=* --enablerepo=rhel-8-* 2>/dev/null | grep ^rhel-8 | awk '{print $1}'`"

cd $REPODIR || exit 1
for repo in $REPOS; do
    echo
    echo "$progname: mirroring $repo to $REPODIR/$repo"
    nice reposync \
        $REPOSYNCARGS \
	--repoid=$repo 2>&1 | tee $LOGFILE
done

#for repo in $REPOS; do
#    echo "Clearing out-of-date RPMs from: $REPODIR"
#    find $REPODIR/$repo/ -name \*.rpm | sort -u | while read name; do
#	#echo Checking $name
#	rpmname=`basename $name`
#	grep -q "\[SKIPPED\] $rpmname: Already downloaded" $LOGFILE && continue
#
#	echo "Flushing unsynced $name"
#	echo rm -f $name && continue
#    done
#    echo "Warning: reposync logged to $LOGFILE unsuccessful"
#    echo "    Not scrubbing mismaatched RPMs"
#done

# Run createrepo even if reposync fails: risk of partial
# update causing confusion has to be traded off against having
# partially successful updates not available at all.
#
# Do not check against timestamps of downloaded packages, those mirror
# upstream timestamps, not local download times
#
# Use --update, it's vastly more efficient for large repositories

for repo in $REPOS; do
    createrepo $REPODIR/$repo || exit 1
done

#nice createrepo --update $REPODIR

## Define other directories to hardlink up
#LINKDIRS=''
#nice /usr/sbin/hardlink -v $LINKDIRS $REPODIR
