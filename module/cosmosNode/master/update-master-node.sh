#!/bin/bash

GRAVITY_CONFIG_FILE="/root/.gravity/config"
GRAVITY_GENESIS_FILE="/root/.gravity/config/genesis.json"
BUCKET_MASTER_GENESIS_FILE="master/genesis.json"
PEER_INFO="peerInfo"

GIT_HUB_USER=$1
GIT_HUB_PASS=$2
GIT_HUB_EMAIL=$3

echo "Get pull updates"
git pull origin config

echo "extracting validator address"
validatorKey="$(jq .address $PEER_INFO/validator1.json)"
echo "adding gravity genesis account"
gravity add-genesis-account $validatorKey 10000000stake

echo "Collecting gentxs files in config gentx"
cp $PEER_INFO/gentx/*.json $GRAVITY_CONFIG_FILE/gentx/
echo "Collecting gentxs"
gravity collect-gentxs

# update genesis file and remove peer information PEER_INFO------
rm -r master, peerInfo
mkdir master
touch $BUCKET_MASTER_GENESIS_FILE
echo "Copying genesis file"
cp $GRAVITY_GENESIS_FILE $BUCKET_MASTER_GENESIS_FILE
echo "git add command"
git add .
echo "git add git config command"
git config --global user.email $GIT_HUB_EMAIL
git config --global user.name $GIT_HUB_USER
git remote set-url origin https://$GIT_HUB_USER:$GIT_HUB_PASS@github.com/sunnyk56/gravity-bridge.git
echo "git commit command"
git commit -m "add genesis file"
echo "git push command"
git push origin config

# Resets the blockchain database, removes address book files and start the node
gravity unsafe-reset-all
gravity --home /root/.gravity/ --address tcp://0.0.0.0:26655 --rpc.laddr tcp://0.0.0.0:26657 --grpc.address 0.0.0.0:9090 --log_level error --p2p.laddr tcp://0.0.0.0:26656 --rpc.pprof_laddr 0.0.0.0:6060 start

