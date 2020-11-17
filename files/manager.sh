#!/bin/bash

#NFS="fs-089b4570.efs.us-east-2.amazonaws.com:/"
NFS="fs-74018c0c.efs.us-east-2.amazonaws.com:/"
MANAGER="/data/tools/token_manager"
WORKER="/data/tools/token_workers"
export DEBIAN_FRONTEND=noninteractive
apt update && apt dist-upgrade -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt upgrade -y
apt-get -y install docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
apt install nfs-common -y
mkdir /data
echo "${NFS} /data nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport         0       0">>/etc/fstab
mount -a

sleep 180
$(cat ${MANAGER} | awk 'NR==3')
