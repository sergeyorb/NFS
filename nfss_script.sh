#!/bin/bash

# INSTALL NFS
yum install -y nfs-utils mc

# FIREWALL
systemctl enable firewalld --now
firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd" --permanent
firewall-cmd --reload

# ENABLE NFS
systemctl enable nfs --now

# NFS DIRECTORY
mkdir -p /srv/nfs-server/share-01
chown -R nfsnobody:nfsnobody /srv/nfs-server
chmod 0777 /srv/nfs-server/share-01

# EXPORTS
cat << EOF > /etc/exports
/srv/nfs-server 192.168.56.101/32(rw,sync,root_squash)
EOF
exportfs -r
