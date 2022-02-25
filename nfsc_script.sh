#!/bin/bash

# INSTALL NFS
yum install -y nfs-utils mc

# FIREWALL
systemctl enable firewalld --now

# FSTAB
echo "192.168.56.100:/srv/nfs-server/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab

# RELOAD
systemctl daemon-reload
systemctl restart remote-fs.target
