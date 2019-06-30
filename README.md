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

Unfortunately, some channels in that list are not currently available 
such as the "satellite" or "ansible" channels.

rhel-8-x86_64.cfg
=================

This is for /etc/mock/rhel-8-x86_64.cfg, along with "mock". It should be
displaced by epel-8-x86_64.cfg after CentOS 8 and EPEL 8 release that.

Some packages require "best=1" to be reset to "best=0" to resolve dependencies with the new "modules" packages.

Nico Kadel-Garcia <nkadel@gmail.com>
