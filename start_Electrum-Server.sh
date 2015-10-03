#!/bin/bash -x
###### This provides a generic example to start an Electrum--server server for a coin
# Variables are given with defaults! 
# Either set variables on command line overriding default in this script:
#     USER=coin ELECTRUM_DASH_SVR_IRCNICK=mazaclub ./start_Electrum--server.sh 
# OR
# change the default in this script
#     ELECTRUM_DASH_SVR_IRCNICK=${ELECTRUM_DASH_SVR_IRCNICK:-mazaclub}}
#     ->>  ELECTRUM_DASH_SVR_IRCNICK=${ELECTRUM_DASH_SVR_IRCNICK:-metalurgist}}
#     OR   ELECTRUM_DASH_SVR_IRCNICK=metalurgist
#
# 

###########################
### Variables supported by mazaclub/${COIND}-base images
###  - these are used INSIDE the docker container, 
###    and provided to it via -e ENV=var in docker run statements
###  - these variables are required to be set
###  - TXINDEX=1 is required for Electrum--server operation
###  - it is HIGHLY recommended to NOT REINDEX your blockchain 
###    and instead download a fresh copy with TXINDEX=1 set

COIN=${COIN:-bitcoin}
COIN_SYM=${COIN_SYM:-dash}
COIND=${COIND:-localhost}
RPCPORT=${RPCPORT:-8332}
COINDIR=${COINDIR:-/home/${USER}/.${COIN}}
TXINDEX=${TXINDEX:-1}

###############################################
## Variables for start_Electrum--server.sh 
##  - these are NOT used inside the container, these are 
##    only used to START the container

IMAGE="${IMAGE:-mazaclub/electrum-dash-server:${COIN_SYM}}"
GROUP="mercury"
APP="${COIN}"
HOST_DATA_PREFIX="/opt/data/electrum-dash-server"
DATA_VOLDIR="/var/electrum-dash-server/${COIN_SYM}"
HOSTNAME="${COIN_SYM}.mercury.${DOMAIN}"
NAME="${GROUP}_${APP}"
#################################

#################################
## Variables supported in /app/start.sh
###  - these are used INSIDE the docker container, 
###    and provided to it via -e ENV=var in docker run statements
###  - thes show their default values in /app/start.sh
###  - used to configure electrum-dash-server.conf
###  - If you are behind NAT, and are connecting your server to IRC
###    ELECTRUM_DASH_SVR_REPORT_HOST
###    ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT
###    ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT
###    are needed to provide IRC clients with your correct public DNS/ports

#ELECTRUM_DASH_SVR_PRUNING_LIMIT=${ELECTRUM_DASH_SVR_PRUNING_LIMIT:-10000}
#ELECTRUM_DASH_SVR_HOSTNAME=${ELECTRUM_DASH_SVR_HOSTNAME:-${HOSTNAME}}
#ELECTRUM_DASH_SVR_PORT=${ELECTRUM_DASH_SVR_PORT:-50001}
#ELECTRUM_DASH_SVR_SSLPORT=${ELECTRUM_DASH_SVR_SSL_PORT:-50002}
#RPCUSER=${RPCUSER:-$(grep rpcuser "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
#RPCPASSWORD=${RPCPASSWORD:-$(grep rpcpassword "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
#ELECTRUM_DASH_SVR_PASSWORD=$(egrep '^password =' /etc/electrum-dash-server.conf|awk -F= '{print $2}')
#ELECTRUM_DASH_SVR_IRCNICK=${ELECTRUM_DASH_SVR_IRCNICK:-$[ 1 + $[RANDOM % 99999 ]]__mazaclub}
#ELECTRUM_DASH_SVR_BLOCK_CACHE_SIZE=${ELECTRUM_DASH_SVR_BLOCK_CACHE_SIZE:-120}
#ELECTRUM_DASH_SVR_DONATION_ADDR=${ELECTRUM_DASH_SVR_DONATION_ADDR:-1CnCRnTLW1uQaFWguRsvmQJXWA3G9nfa9T}
#ELECTRUM_DASH_SVR_REPORT_HOST=${ENCMPASS_MERCURY_REPORT_HOST:-${ELECTRUM_DASH_SVR_HOSTNAME}}
#ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT=${ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT:-${ELECTRUM_DASH_SVR_PORT}}
#ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT=${ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT:-${ELECTRUM_DASH_SVR_SSL_PORT}}
#######################################



ELECTRUM_DASH_SVR_PRUNING_LIMIT=${ELECTRUM_DASH_SVR_PRUNING_LIMIT:-10000}
ELECTRUM_DASH_SVR_HOSTNAME=${ELECTRUM_DASH_SVR_HOSTNAME:-dash.mercury.docker.local}
ELECTRUM_DASH_SVR_PORT=${ELECTRUM_DASH_SVR_PORT:-50001}
ELECTRUM_DASH_SVR_SSL_PORT=${ELECTRUM_DASH_SVR_SSL_PORT:-50002}
ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT=${ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT:-50001}
ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT=${ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT:-50002}
ELECTRUM_DASH_SVR_IRCNICK=${ELECTRUM_DASH_SVR_IRCNICK:-dev_mazaclub}
ELECTRUM_DASH_SVR_BLOCK_CACHE_SIZE=${ELECTRUM_DASH_SVR_BLOCK_CACHE_SIZE:-120}
ELECTRUM_DASH_SVR_DONATION_ADDR=${ELECTRUM_DASH_SVR_DONATION_ADDR:-1CnCRnTLW1uQaFWguRsvmQJXWA3G9nfa9T}
ELECTRUM_DASH_SVR_REPORT_HOST=${ENCMPASS_MERCURY_REPORT_HOST:-dash.mercury.maza.club}



run () {
docker run -d \
  -h "${HOSTNAME}" \
  --name=${NAME} \
  --restart=always \
  -p ${ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT}:${ELECTRUM_DASH_SVR_SSL_PORT} \
  -p ${ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT}:${ELECTRUM_DASH_SVR_PORT} \
  -p ${ELECTRUM_DASH_SVR_OUTSIDE_DAEMON_PORT}:${ELECTRUM_DASH_SVR_DAEMON_PORT} \
  -p ${OUTSIDE_RPCPORT}:${RPCPORT} \
  -v ${HOST_DATA_PREFIX}/${COIN}:${COINDIR} \
  -v ${HOST_DATA_PREFIX}/electrum-dash-server:${DATA_VOLDIR} \
  -v ${HOST_DATA_PREFIX}/log:/var/log/electrum-dash-server-${COIN}.log \
  -e COIN=${COIN} \
  -e COIN_SYM=${COIN_SYM} \
  -e COIND=${COIND} \
  -e RPCPORT=${RPCPORT} \
  -e COINDIR=${COINDIR} \
  -e TXINDEX=${TXINDEX} \
  -e ELECTRUM_DASH_SVR_PRUNING_LIMIT=${ELECTRUM_DASH_SVR_PRUNING_LIMIT} \
  -e ELECTRUM_DASH_SVR_HOSTNAME=${ELECTRUM_DASH_SVR_HOSTNAME} \
  -e ELECTRUM_DASH_SVR_PORT=${ELECTRUM_DASH_SVR_PORT} \
  -e ELECTRUM_DASH_SVR_SSL_PORT=${ELECTRUM_DASH_SVR_SSL_PORT} \
  -e ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT=${ELECTRUM_DASH_SVR_OUTSIDE_TCP_PORT} \
  -e ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT=${ELECTRUM_DASH_SVR_OUTSIDE_SSL_PORT} \
  -e ELECTRUM_DASH_SVR_IRCNICK=${ELECTRUM_DASH_SVR_IRCNICK} \
  -e ELECTRUM_DASH_SVR_BLOCK_CACHE_SIZE=${ELECTRUM_DASH_SVR_BLOCK_CACHE_SIZE} \
  -e ELECTRUM_DASH_SVR_DONATION_ADDR=${ELECTRUM_DASH_SVR_DONATION_ADDR} \
  -e ELECTRUM_DASH_SVR_REPORT_HOST=${ENCMPASS_MERCURY_REPORT_HOST} \
  ${IMAGE}

}

start () {
docker start ${NAME}
}
stop () {
docker stop ${NAME}
}

remove () {
docker rm ${NAME}
}


case ${1} in
 remove) remove
	;;
  start) start
	;;
   stop) stop
	;;
    run) run
	;;
      *) echo "Usage: ${0} [run|start|stop|remove]"
	;;
esac
