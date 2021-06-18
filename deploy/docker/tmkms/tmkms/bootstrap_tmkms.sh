#!/bin/bash
set -eu

CHAIN_ID="gravity-testnet"
TMKMS_CONFIG_DIR=/home/tmkms

#tmkms init $TMKMS_CONFIG_DIR
#tmkms softsign keygen $TMKMS_CONFIG_DIR/secrets/secret_connection.key

echo -e "\nsecret_connection.key"
cat $TMKMS_CONFIG_DIR/secrets/secret_connection.key

# key from secrets
echo -e "\nsigning.key"
cat $TMKMS_CONFIG_DIR/secrets/signing.key
echo -e "\n"
#tmkms start