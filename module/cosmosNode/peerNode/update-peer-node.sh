
GRAVITY_GENESIS_FILE="/root/.gravity/config/genesis.json"
GRAVITY_CONFIG_FILE="/root/.gravity/config/config.toml"
BUCKET_MASTER_GENESIS_FILE="/root/mainNode/master/genesis.json"
BUCKET_MASTER_SEED_FILE="/root/mainNode/master/seed"
MAIN_NODE="/root/mainNode"


echo "Get pull updates"
git clone -b config https://github.com/sunnyk56/gravity-bridge.git $MAIN_NODE

echo "Copying genesis file"
cp $BUCKET_MASTER_GENESIS_FILE  $GRAVITY_GENESIS_FILE
peerseed=$(cat $BUCKET_MASTER_SEED_FILE)

sed -i 's#persistent_peers = ""#persistent_peers = "'$peerseed'"#g' $GRAVITY_CONFIG_FILE

rm -r $MAIN_NODE

# Resets the blockchain database, removes address book files and start the node
# gravity unsafe-reset-all
gravity --home /root/.gravity/ --address tcp://0.0.0.0:26655 --rpc.laddr tcp://0.0.0.0:26657 --grpc.address 0.0.0.0:9090 --log_level error --p2p.laddr tcp://0.0.0.0:26656 --rpc.pprof_laddr 0.0.0.0:6060 start

