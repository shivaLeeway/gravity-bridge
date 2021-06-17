#!/bin/bash
set -eu

CHAIN_ID="gravity-testnet"
TMKMS_CONFIG_DIR=/home/tmkms

tmkms init $TMKMS_CONFIG_DIR

# copy prebuild tmkms.toml tmkms home
cp configs/tmkms.toml $TMKMS_CONFIG_DIR/tmkms.toml
# replace signing key
cp $TMKMS_CONFIG_DIR/secrets/secret_connection.key /home/tmkms/secrets/kms-identity.key
# key from secrets
cat $TMKMS_CONFIG_DIR/secrets/signing.key
#tmkms start