#!/bin/bash
set -eu

CHAIN_ID="gravity-testnet"
KEYRING="--keyring-backend test"
VALIDATOR_ADDRESS=$(gravity keys show validator1 -a $KEYRING)

gravity query bank balances $VALIDATOR_ADDRESS --chain-id $CHAIN_ID

# Add recipient
gravity keys add recipient $KEYRING
# Put the generated address in a variable for later use.
RECIPIENT=$(gravity keys show recipient -a $KEYRING)

# sed tokens to the recipient
gravity tx bank send $VALIDATOR_ADDRESS $RECIPIENT 700stake --chain-id $CHAIN_ID $KEYRING -y

# sed tokens to the recipient
gravity tx bank send $VALIDATOR_ADDRESS $RECIPIENT 600samoleans --chain-id $CHAIN_ID $KEYRING -y

# await tx confirmation
echo "sleeping 5 sec"
sleep 5

# check that the recipient account did receive the tokens.
echo -e "\n RECIPIENT balance:"
gravity query bank balances $RECIPIENT --chain-id $CHAIN_ID

# check that validator sent the tokens.
echo -e "\n VALIDATOR1 balance:"
gravity query bank balances $VALIDATOR_ADDRESS --chain-id $CHAIN_ID