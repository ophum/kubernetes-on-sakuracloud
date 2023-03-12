#!/bin/sh

sudo apt-get update
sudo apt-get install lvm2 -y

pvcreate /dev/sdb
vgcreate lvmvg /dev/vdb
