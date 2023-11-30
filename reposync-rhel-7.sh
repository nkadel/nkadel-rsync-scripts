#!/bin/bash
#
# reposync-rhel-7.sh - reposync RHEL rpms or SRPM's
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
#    subscription-manager repos --enable=codeready-builder-for-rhel-7-x86_64-debug-rpms
#
# Wild cards also accepted:
#    subscription-manager repos --enable=*-rhel-7-*

# Sort things correctly
export LANG=C

progname=`basename $0`

#set -e
set -o pipefail

RSYNCARGS="$@"

REPODIR=/var/www/linux/reposync/rhel/7/
cd $REPODIR || exit 1

# Exit on failures to pipes
set -o pipefail

REPOSYNCARGS=""
# Download only newest version
#REPOSYNCARGS="$REPOSYNCARGS --newest"
# Clean up after old package failures
REPOSYNCARGS="$REPOSYNCARGS --delete"
# Download metadata
#REPOSYNCARGS="$REPOSYNCARGS --download-metadata"

# Set repos manually
#REPOS=""
#REPOS="$REPOS rhel-7-for-x86_64"

# Deduce subscribed repos. Repos are not even listed if not *subscribed*!!!
# "dnf repolist" contans undesired headers
REPOS="`subscription-manager repos --list | grep 'Repo ID:' | awk '{print $NF}' | LANG=C sort -r`"

# Filter out channels that are empty, or broken, on RHEL 7 subscriptions
echo "Filtering REPOS for undesirable, satellite, and -7- channels"
#REPOS="`echo "$REPOS" | grep rhel-7`"

set -o pipefail
for repo in $REPOS; do
    case $repo in
	*-7-*)
	    echo Skipping: $repo
	    continue
	    ;;
	*-9-*)
	    echo Skipping: $repo
	    continue
	    ;;
	*-debug-*)
	    echo Skipping: $repo
	    continue
	    ;;
	*-e4s-*)
	    echo Skipping: $repo
	    continue
	    ;;
	*-eus-*)
	    echo Skipping: $repo
	    continue
	    ;;
	*-sap-*)
	    echo Skipping: $repo
	    continue
	    ;;
	satellite-*)
	    echo Skipping: $repo
	    continue
	    ;;
	*ansible*)
	    echo Skipping: $repo
	    continue
	    ;;
	rh-gluster-3*)
	    echo Skipping: $repo
	    continue
	    ;;
    esac	
    echo
    if [ -e /var/log/reposync/$repo.log ]; then
	mv -f /var/log/reposync/$repo.log /var/log/reposync/$repo.log.1
    fi
    num=0
    while [ $num -lt 10 ]; do
	echo "$progname: mirroring $REPODIR/$repo"
	echo "$progname: logging in /var/log/reposync/$repo.log"
	nice reposync \
             $REPOSYNCARGS \
	     --repoid=$repo 2>&1 | tee /var/log/reposync/$repo.log && break
	num=`expr $num + 1`
	echo "    Run $num failed, retrying"
    done
    rm -rf $repo/.repodata
    nice createrepo --update $repo | tee -a /var/log/reposync/$repo.log
done

# Particularly useful for duplicate packages in storage and resilience channels
echo Hardlinking based on content only in $REPODIR
nice hardlink -v -c $REPODIR
