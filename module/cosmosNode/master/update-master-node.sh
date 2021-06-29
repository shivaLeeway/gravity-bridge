#!/bin/bash

GRAVITY_CONFIG_FILE="/root/.gravity/config"
GRAVITY_GENESIS_FILE="/root/.gravity/config/genesis.json"
BUCKET_MASTER_GENESIS_FILE="master/genesis.json"
PEER_INFO="peerInfo"

echo "Get pull updates"
RUN git pull origin main

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
git config --global user.email "sunnyk@leewayhertz.com"
git config --global user.name "sunnyk56"
git remote set-url origin https://sunnyk56:Leeway321@github.com/sunnyk56/gravity-bridge-1.git
echo "git commit command"
git commit -m "add genesis file"
echo "git push command"
git push origin main

# Resets the blockchain database, removes address book files and start the node
gravity unsafe-reset-all
gravity --home /root/.gravity/ --address tcp://0.0.0.0:26655 --rpc.laddr tcp://0.0.0.0:26657 --grpc.address 0.0.0.0:9090 --log_level error --p2p.laddr tcp://0.0.0.0:26656 --rpc.pprof_laddr 0.0.0.0:6060 start

