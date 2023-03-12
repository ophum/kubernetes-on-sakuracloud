#!/bin/sh

sudo apt-get update
sudo apt-get install lvm2 -y

pvcreate /dev/vdb
vgcreate lvmvg /dev/vdb
