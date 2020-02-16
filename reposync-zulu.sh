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

#set -e
set -o pipefail

RSYNCARGS="$@"

REPODIR=/var/www/linux/reposync/
cd $REPODIR || exit 1

# Exit on failures to pipes
set -o pipefail

REPOSYNCARGS=""
# Download only newest version
REPOSYNCARGS="$REPOSYNCARGS --newest"
# Clean up after old package failures
REPOSYNCARGS="$REPOSYNCARGS --delete"
# Download metadata
REPOSYNCARGS="$REPOSYNCARGS --download-metadata"

# Set repos manually
REPOS="zulu"

for repo in $REPOS; do
    echo
    echo "$progname: mirroring $REPODIR/$repo"
    echo "$progname: logging in $REPODIR/$repo.log"
    nice reposync \
        $REPOSYNCARGS \
	--repoid=$repo 2>&1 | tee $repo.log
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
    nice createrepo --quiet $REPODIR/$repo
done

#echo Hardlinking based on content only in $REPODIR
#nice hardlink -v -c $REPODIR
