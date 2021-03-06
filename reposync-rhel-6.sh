#!/bin/sh
#
# reposync-rhel-8.sh - reposync RHEL RPMS
#    Requires registration of RHEL channels
#
# License: GPL
# Author: Nico Kadel-Garcia <nkadel@gmail.com>

# Sort things correctly
export LANG=C

progname=`basename $0`

RSYNCARGS="$@"

REPODIR=/var/www/linux/reposync/rhel/6Server/

# Verify GPG keys for RHEL
rpm -q gpg-pubkey-fd431d51-4ae0493b >/dev/null || exit 1

LOGFILE=/var/log/reposync/${progname}.log
rm -f $LOGFILE && \
    cat /dev/null >$LOGFILE || exit 1

nice reposync \
    --arch=src \
    --newest \
    --repoid=rhel6-source \
    --gpgcheck \
    --download_path=$REPODIR > $LOGFILE

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

# Run createrepo even if reposync fails: risk of partial
# update causing confusion has to be traded off against having
# partially successful updates not available at all.
#
# Do not check against timestamps of downloaded packages, those mirror
# upstream timestamps, not local download times
#
# Use --update, it's vastly more efficient for large repositories
nice createrepo --update $REPODIR

## Define other directories to hardlink up
#LINKDIRS=''
#nice /usr/sbin/hardlink -v $LINKDIRS $REPODIR
