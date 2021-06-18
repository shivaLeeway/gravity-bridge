#!/bin/bash
set -eu

GRAVITY_HOME_DIR="/root/.gravity"

echo "priv_validator_key.json "
cat $GRAVITY_HOME_DIR/config/priv_validator_key.json
echo "priv_validator_state.json"
cat $GRAVITY_HOME_DIR/data/priv_validator_state.json

tm-signer-harness extract_key --tmhome=$GRAVITY_HOME_DIR --output=$GRAVITY_HOME_DIR/signing.key

# generate template based on chain
chmod +x gen-validator-integration-cfg.sh
TMHOME=$GRAVITY_HOME_DIR sh ./gen-validator-integration-cfg.sh

echo "signing.key"
cat $GRAVITY_HOME_DIR/signing.key
echo "tmkms.toml"
cat /root/~/tmkms.toml
echo "secret_connection.key"
cat secret_connection.key