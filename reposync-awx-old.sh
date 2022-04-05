#!/bin/sh
#
# reposync-awx-old-srpms.sh - reposync awx-old AWX srpms
#
# License: GPL
# Author: Nico Kadel-Garcia <nkadel@gmail.com>

# Sort things correctly
export LANG=C

set -o pipefail
set -e

progname=`basename $0`

RSYNCARGS="$@"

REPODIR=/var/www/linux/reposync/awx-old

LOGFILE=/var/log/reposync/${progname}.log
rm -f $LOGFILE && \
    cat /dev/null >$LOGFILE || exit 1

if [ ! -s /etc/yum.repos.d/awx-old.repo ]; then
    echo Error: Missing repo file: /etc/yum.repos.d/awx-old.repo >&2
    exit 1
else
    diff -u /etc/yum.repos.d/awx-old.repo awx-old.repo || exit 1
fi

REPOS="$REPOS awx-old"
for repo in $REPOS; do
    nice reposync \
	 --newest \
	 --delete \
	 --repoid=$repo \
	 --source \
	 --download_path=$REPODIR 2>&1 | tee $LOGFILE

    # Use --update, it's vastly more efficient for large repositories
    nice createrepo --update $REPODIR/$repo
    if [ -d $REPODIR/$repo/src ]; then
	nice createrepo --update $REPODIR/$repo/src
    fi
done
