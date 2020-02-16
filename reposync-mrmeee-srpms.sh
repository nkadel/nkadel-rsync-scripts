#!/bin/sh
#
# reposync-mrmeee-srpms.sh - reposync mrmeee AWX srpms
#
# License: GPL
# Author: Nico Kadel-Garcia <nkadel@gmail.com>

# Sort things correctly
export LANG=C

set -o pipefail

progname=`basename $0`

RSYNCARGS="$@"

REPODIR=/var/www/linux/reposync/mrmeee-ansible-awx/

LOGFILE=/var/log/reposync/${progname}.log
rm -f $LOGFILE && \
    cat /dev/null >$LOGFILE || exit 1

if [ ! -s /etc/yum.repos.d/mrmeee-ansible-awx.repo ]; then
    echo Error: Missing repo file: /etc/yum.repos.d/mrmeee-ansible-awx.repo >&2
    exit 1
else
    diff -u /etc/yum.repos.d/mrmeee-ansible-awx.repo mrmeee-ansible-awx.repo || exit 1
fi

REPOS="$REPOS mrmeee-ansible-awx-source"
for repo in $REPOS; do
    nice reposync \
	 --newest \
	 --delete \
	 --repoid=$repo \
	 --download-path=$REPODIR 2>&1 | tee $LOGFILE

    if [ $? -eq 0 ]; then
	echo "Clearing out-of-date RPMs from: $REPODIR"
	find $REPODIR -name \*.rpm | sort -u | while read name; do
	    #echo Checking $name
	    rpmname=`basename $name`
	    grep -q " Skipping existing $rpmname$" $LOGFILE && continue

	    echo "Flushing unsynced $name"
	    rm -f $name
	done
    else
	echo "Warning: reposync logged to $LOGFILE unsuccessful"
	echo "    Not scrubbing mismaatched RPMs"
    fi

    # Use --update, it's vastly more efficient for large repositories
    nice createrepo --update $REPODIR
done
