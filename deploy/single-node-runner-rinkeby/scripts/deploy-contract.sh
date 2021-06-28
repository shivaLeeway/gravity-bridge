#!/bin/bash
set -eu

echo "building environment"

# Initial dir
CURRENT_WORKING_DIR=$(pwd)
# Name of the network to bootstrap
CHAINID="testchain"
# Name of the gravity artifact
GRAVITY=gravity
# The name of the gravity node
GRAVITY_NODE_NAME="gravity"
# The address to run gravity node
GRAVITY_HOST="0.0.0.0"
# Home folder for gravity config
GRAVITY_HOME="$CURRENT_WORKING_DIR/$CHAINID/$GRAVITY_NODE_NAME"
# Home flag for home folder
GRAVITY_HOME_FLAG="--home $GRAVITY_HOME"

# This key is the private key for the public key defined in ETHGenesis.json
# where the full node / miner sends its rewards. Therefore it's always going
# to have a lot of ETH to pay for things like contract deployments
ETH_MINER_PRIVATE_KEY=e0b21b1d80e53f38734a3ed395796956b50c637916ddbb6cedb096b848053d2d
ETH_MINER_PUBLIC_KEY=0x97D5F5D4fDf83b9D2Cb342A09b8DF297167a73d0

# The host of ethereum node
ETH_HOST="0.0.0.0"

#-------------------- Run gravity node --------------------

echo "Starting $GRAVITY_NODE_NAME"
$GRAVITY $GRAVITY_HOME_FLAG start --pruning=nothing &>/dev/null

#-------------------- Run ethereum (geth/rinkeby) --------------------

geth --rinkeby --syncmode "light" \
                               --http \
                               --http.port "8545" \
                               --http.addr "$ETH_HOST" \
                               --http.corsdomain "*" \
                               --http.vhosts "*" \
                               &>/dev/null

#-------------------- Apply ethereum contract --------------------

echo "Waiting for light to to be synced"
sleep 120

echo "account coins: $(geth --rinkeby attach ipc:/root/.ethereum/rinkeby/geth.ipc console --exec "web3.eth.getBalance('$ETH_MINER_PUBLIC_KEY')")"

echo "Applying contracts"

GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge/
cd $GRAVITY_DIR/solidity

npx ts-node \
    contract-deployer.ts \
    --cosmos-node="http://$GRAVITY_HOST:26657" \
    --eth-node="http://$ETH_HOST:8545" \
    --eth-privkey="$ETH_MINER_PRIVATE_KEY" \
    --contract=artifacts/contracts/Gravity.sol/Gravity.json \
    --test-mode=false | grep "Gravity deployed at Address" | grep -Eow '0x[0-9a-fA-F]{40}' >> $GRAVITY_HOME/eth_contract_address

CONTRACT_ADDRESS=$(cat $GRAVITY_HOME/eth_contract_address)

echo "Contract address: $CONTRACT_ADDRESS"

echo "Terminating"
sleep 10

# return back to home
cd $CURRENT_WORKING_DIR