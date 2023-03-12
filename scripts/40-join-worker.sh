#!/bin/sh

kubeadm join $CONTROL_PLANE_HOST:$CONTROL_PLANE_PORT --token $TOKEN --discovery-token-ca-cert-hash sha256:$HASH

