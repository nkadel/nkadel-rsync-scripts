nkadel-rsync-scripts
====================

Rsync scripts for various upstream mirrors to local disk

reposync-rhel-*..sh
-------------------

Reposyncs RHEL servers with active subscriptions. Reads entire
subscription with "configuration-manager" and attempts to read all
channels.

Unfortunately, some channels in that list may not be currently available 
with a normal subscription such as the "satellite" channels.

rsync-centos.sh
---------------

CentOS has gotten weird and stoppoed publishing to the old
vault.centos.org mirror. And the "stream" model ignores the "."
releases. To proovide those, grab the reease numbered ".iso" images
and set up a local set of yum repos from those, hardlinked to these
reposync mirrors for efficient storage.

Nico Kadel-Garcia <nkadel@gmail.com>
