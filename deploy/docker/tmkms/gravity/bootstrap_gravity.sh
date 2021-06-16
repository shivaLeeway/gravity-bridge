#!/bin/bash
set -eu

CHAIN_ID="gravity-testnet"
KEYRING="--keyring-backend test"
COINS="100000000000stake,100000000000samoleans"
VALIDATOR_NAME=validator1

# init one validator

gravity keys add $VALIDATOR_NAME $KEYRING
VALIDATOR_ADDRESS=$(gravity keys show $VALIDATOR_NAME -a $KEYRING)

gravity init $VALIDATOR_NAME --chain-id=$CHAIN_ID
gravity add-genesis-account $VALIDATOR_ADDRESS $COINS

ETH_ADDRESS=$(gravity eth_keys add --output=text --dry-run=true | grep address: | sed 's/address://g')
# The command definition is:  gravity gentx [key_name] [amount] [eth-address] [orchestrator-address] [flags]
gravity gentx $VALIDATOR_NAME 100000000stake $ETH_ADDRESS $VALIDATOR_ADDRESS --chain-id $CHAIN_ID $KEYRING
gravity collect-gentxs

GRAVITY_NAME="gravity"
GRAVITY_HOME_DIR="/root/.gravity"
GRAVITY_CONFIG_DIR="$GRAVITY_HOME_DIR/config"
GRAVITY_CONFIG_TOML="$GRAVITY_CONFIG_DIR/config.toml"
GRAVITY_APP_TOML="$GRAVITY_CONFIG_DIR/app.toml"

echo -e "\n Config toml:"
cat $GRAVITY_CONFIG_TOML
echo -e "\n App toml:"
cat $GRAVITY_APP_TOML


# Switch sed command in the case of linux
fsed() {
  if [ `uname` = 'Linux' ]; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Update node hosts and some config
fsed "s#\"tcp://127.0.0.1:26656\"#\"tcp://0.0.0.0:26656\"#g" $GRAVITY_CONFIG_TOML
fsed "s#\"tcp://127.0.0.1:26657\"#\"tcp://0.0.0.0:26657\"#g" $GRAVITY_CONFIG_TOML
fsed 's#addr_book_strict = true#addr_book_strict = false#g' $GRAVITY_CONFIG_TOML
fsed 's#external_address = ""#external_address = "tcp://'$GRAVITY_NAME:26656'"#g' $GRAVITY_CONFIG_TOML
fsed 's#enable = false#enable = true#g' $GRAVITY_APP_TOML
fsed 's#swagger = false#swagger = true#g' $GRAVITY_APP_TOML

