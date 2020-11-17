#!/bin/bash

#NFS="fs-089b4570.efs.us-east-2.amazonaws.com:/"
NFS="fs-74018c0c.efs.us-east-2.amazonaws.com:/"
MANAGER="/data/tools/token_manager"
WORKER="/data/tools/token_workers"
USRGIT="miusuariogit"
REPO="runa.git"
TOK=03263be9cc8228e79a841d1fc1dec6882761ca1b
deploy="/var/log/deploy.log"

touch $deploy
export DEBIAN_FRONTEND=noninteractive
apt update && apt dist-upgrade -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt upgrade -y
apt-get -y install docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
apt install nfs-common -y
echo "Todo instalado" >> $deploy
mkdir /data
echo "${NFS} /data nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport         0       0">>/etc/fstab
mount -a

mkdir -p /data/tools
echo "Montada la unidad /data y creada la carpeta tools">> $deploy
echo "Esperando 1 minuto antes de proseguir" >> $deploy
sleep 60
echo "Creando Swarm" >> $deploy
docker swarm init 
echo "Creando los tokens" >>  $deploy
docker swarm join-token manager > ${MANAGER}
docker swarm join-token worker > ${WORKER}
docker network create --driver=overlay --attachable proxy


#########################
####  Despliegue	#####
#########################
echo "Labor de Despliegue:" >>  $deploy
cd /data
echo "Clonando" >> $deploy
git clone https://${TOK}@github.com/${USRGIT}/${REPO}
cd runa/
echo "Creando el Stack" >>  $deploy
docker stack deploy -c runacode.yml runa
echo "Gestionando Monitoreo" >>  $deploy
mkdir -p /var/log/swarm
mv /data/runa/tools/monitor.sh /data/tools/


################################
####  Crontab para monitor  ####
################################
(crontab -l && echo "59 23 31 12 * echo 'Happy New Year'") | crontab -
(crontab -l && echo "*/1 * * * * sh /data/tools/monitor.sh") | crontab -
