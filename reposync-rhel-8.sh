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

REPODIR=/var/www/linux/reposync/rhel/8/
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
#REPOS="$REPOS rhel-8-for-x86_64-baseos-rpms"
#REPOS="$REPOS rhel-8-for-x86_64-appstream-rpms"

# Deduce subscribed repos. Repos are not even listed if not *subscribed*!!!
# "dnf repolist" contans undesired headers
REPOS="`subscription-manager repos --list | grep 'Repo ID:' | awk '{print $NF}' | LANG=C sort -r`"


# Filter out channels that are empty, or broken, on RHEL 8 subscriptions
echo "Filtering REPOS for undesirable, satellite, and -7- channels"
#REPOS="`echo "$REPOS" | sed /^satellite-/d | sed /-7-/d | sed /^ansible/d | grep rhel-8`"
REPOS="`echo "$REPOS" | sed /-sap-/d | sed /-7-/d | sed /^satellite-/d | sed /-debug-/d | grep rhel-8 | sed /-eus-/d | sed /rh-gluster-3/d`"


REPOS="`echo "$REPOS" | sed /-7-/d`"
REPOS="`echo "$REPOS" | sed /-debug-/d`"
REPOS="`echo "$REPOS" | sed /-eus-/d`"
REPOS="`echo "$REPOS" | sed /-sap-/d`"
REPOS="`echo "$REPOS" | sed /^satellite-/d`"
REPOS="`echo "$REPOS" | sed /rh-gluster-3/d`"
REPOS="`echo "$REPOS" | sed /ansible-2.8-/d`"
REPOS="`echo "$REPOS" | sed /ansible-2-/d`"

set -o pipefail
for repo in $REPOS; do
    echo
    rm -f /var/log/reposync/$repo.log
    num=0
    while [ $num -lt 10 ]; do
	echo "$progname: mirroring $REPODIR/$repo"
	echo "$progname: logging in /var/log/reposync/$repo.log"
	nice reposync \
             $REPOSYNCARGS \
	     --repoid=$repo 2>&1 2>&1 | tee /var/log/reposync/$repo.log && break
	num=`expr $num + 1`
	echo "    Run $num failed, retrying"
    done
    rm -rf $repo/.repodata
    nice createrepo $repo | tee -a /var/log/reposync/$repo.log
done

# Particularly useful for duplicate packages in storage and resilience channels
echo Hardlinking based on content only in $REPODIR
nice hardlink -v -c $REPODIR
