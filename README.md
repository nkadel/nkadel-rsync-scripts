nkadel-rsync-scripts
====================

Rsync scripts for various upstream mirrors to local disk

reposync-rhel-6.sh
==================

Obsolete tool to reposync RHEL 6 servers with active subscriptions

reposync-rhel-8.sh
==================

Reposyncs RHEL 8 servers with active subscriptions. Reads entire
subscription with "configuration-manager" and attempts to read all
channels.

Unfortunately, some channels in that list are not available without
*additional* licensing, such as the "satellite" channels. Others are
apparently still empty, such as the "ansible" channels.

Nico Kadel-Garcia <nkadel@gmail.com>
