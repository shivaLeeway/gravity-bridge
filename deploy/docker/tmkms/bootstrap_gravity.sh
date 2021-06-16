#!/bin/bash
set -eu

CHAIN_ID="gravity-testnet"
KEYRING="--keyring-backend test"
COINS="100000000000stake,100000000000samoleans"

# init one validator

gravity keys add validator1 $KEYRING
VALIDATOR_ADDRESS=$(gravity keys show validator1 -a $KEYRING)

gravity init validator1 --chain-id=$CHAIN_ID
gravity add-genesis-account $VALIDATOR_ADDRESS $COINS

ETH_ADDRESS=$(gravity eth_keys add --output=text --dry-run=true | grep address: | sed 's/address://g')
# The command definition is:  gravity gentx [key_name] [amount] [eth-address] [orchestrator-address] [flags]
gravity gentx validator1 100000000stake $ETH_ADDRESS $VALIDATOR_ADDRESS --chain-id $CHAIN_ID $KEYRING
gravity collect-gentxs

gravity_name="gravity"
gravity_home_dir="/root/.gravity"
gravity_config_dir="$gravity_home_dir/config"
gravity_config_toml="$gravity_config_dir/config.toml"
gravity_app_toml="$gravity_config_dir/app.toml"

echo -e "\n Config toml:"
cat $gravity_config_toml
echo -e "\n App toml:"
cat $gravity_app_toml


# Switch sed command in the case of linux
fsed() {
  if [ `uname` = 'Linux' ]; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Update node hosts and some config
fsed "s#\"tcp://127.0.0.1:26656\"#\"tcp://0.0.0.0:26656\"#g" $gravity_config_toml
fsed "s#\"tcp://127.0.0.1:26657\"#\"tcp://0.0.0.0:26657\"#g" $gravity_config_toml
fsed 's#addr_book_strict = true#addr_book_strict = false#g' $gravity_config_toml
fsed 's#external_address = ""#external_address = "tcp://'$gravity_name:26656'"#g' $gravity_config_toml
fsed 's#enable = false#enable = true#g' $gravity_app_toml
fsed 's#swagger = false#swagger = true#g' $gravity_app_toml