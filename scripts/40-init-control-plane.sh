#!/bin/sh

${POD_NETWORK_CIDR:=192.168.0.0/16}
${INSTALL_CALICO:=true}
${INSTALL_OPENEBS:=true}

sudo kubeadm init --pod-network-cidr $POD_NETWORK_CIDR

export KUBECONFIG=/etc/kubernetes/admin.conf
if [ "$INSTALL_CALICO" = "true" ]; then 
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
fi

if [ "$INSTALL_OPENEBS" = "true" ]; then
    # install openebs-operator
    kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
    # install lvm-operator
    kubectl apply -f https://openebs.github.io/charts/lvm-operator.yaml
    # install cstor-operator
    kubectl apply -f https://openebs.github.io/charts/cstor-operator.yaml
    # create lvm StorageClass
    cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: openebs-lvmpv
parameters:
  storage: "lvm"
  volgroup: "lvmvg"
provisioner: local.csi.openebs.io
EOF

    # create cstor StorageClass
    cat <<EOF | kubectl apply -f -
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: cstor-csi
provisioner: cstor.csi.openebs.io
allowVolumeExpansion: true
parameters:
  cas-type: cstor
  # cstorPoolCluster should have the name of the CSPC
  cstorPoolCluster: cstor-storage
  # replicaCount should be <= no. of CSPI
  replicaCount: "3"
EOF
fi
