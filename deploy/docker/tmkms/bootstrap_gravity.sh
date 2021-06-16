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