#!/bin/sh

sudo apt-get update
sudo apt-get install open-iscsi -y

sudo systemctl enable --now open-iscsi