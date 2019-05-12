#!/bin/bash
#
# reposync-rhel-6.sh - reposync RHEL rpms or SRPM's
#    Requires registration of RHEL channels
#
# License: GPL
# Author: Nico Kadel-Garcia <nkadel@gmail.com>

# Note that only enabled RHEL repos are mirrored
# To find the list of available subscriptions
#	subscription-manager list --available

# To find the list of available repos:
#	subscription-manager repos --list
#

# Note that this list has its elements deliberately scrambled and with
# inconsistent elements in inconsistent orders. This works to get the
# complete channel list
#
#	subscription-manager repos --list | grep 'Repo ID:' | 
#	subscription-manager repos --list | grep 'Repo ID:' | awk '{print $NF}
#

# Review and activate repos, as desired, based on "Repo ID", i.e.
#    subscription-manager repos --enable=codeready-builder-for-rhel-8-x86_64-debug-rpms
#
# Wild cards also accepted:
#    subscription-manager repos --enable=*-rhel-8-*

# Sort things correctly
export LANG=C

progname=`basename $0`

set -e
set -o pipefail

RSYNCARGS="$@"

REPODIR=/var/www/linux/reposync/rhel/8/
cd $REPODIR || exit 1

# Exit on failures to pipes
set -o pipefail

REPOSYNCARGS=""
#REPOSYNCARGS="$REPOSYNCARGS --newest"
# Clean up after old package failures
REPOSYNCARGS="$REPOSYNCARGS --delete"

# Set repos manually
#REPOS=""
#REPOS="$REPOS rhel-8-for-x86_64-baseos-rpms"
#REPOS="$REPOS rhel-8-for-x86_64-appstream-rpms"

# Deduce subscribed repos. Repos are not even listed if not *subscribed*!!!
# "dnf repolist" contans undesired headers
REPOS="`subscription-manager repos --list | grep 'Repo ID:' | awk '{print $NF}' | LANG=C sort`"

# Filter out channels that are empty, or broken, on RHEL 8 subscriptions
echo "Filtering REPOS for undesirable, satellite, and -7- channels"
REPOS="`echo "$REPOS" | sed /satellite-/d | sed /-7-/d | grep rhel-8`"

for repo in $REPOS; do
    echo
    echo "$progname: mirroring $REPODIR/$repo"
    echo "$progname: logging in $REPODIR/$repo.log"
    nice reposync \
        $REPOSYNCARGS \
	--repoid=$repo 2>&1 2>&1 | tee $repo.log
done

# Run createrepo even if reposync fails: risk of partial
# update causing confusion has to be traded off against having
# partially successful updates not available at all.
#
# Do not check against timestamps of downloaded packages, those mirror
# download times
#
# Use --update, it's vastly more efficient for large repositories

for repo in $REPOS; do
    if [ ! -d $repo ]; then
	echo Warning: $repo missing, skipping createrepo
	continue
    elif [ -d $repo/.repodata ]; then
	echo Warning: $repo/.repodata found, skipping createrepo
	continue
    fi
    echo
    echo
    echo Creating repodata in: $REPODIR/$repo
    nice createrepo --update --quiet $REPODIR/$repo
done

echo Hardlinking based on content only in $REPODIR
nice hardlink -v -c $REPODIR
