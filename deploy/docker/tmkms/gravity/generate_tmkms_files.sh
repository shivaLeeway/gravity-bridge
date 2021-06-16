#!/bin/bash
set -eu

GRAVITY_HOME_DIR="/root/.gravity"

cp -a harness/. $GRAVITY_HOME_DIR

cd $GRAVITY_HOME_DIR

tm-signer-harness extract_key --tmhome=$GRAVITY_HOME_DIR --output=$GRAVITY_HOME_DIR/signing.key

chmod +x gen-validator-integration-cfg.sh
TMHOME=$GRAVITY_HOME_DIR sh ./gen-validator-integration-cfg.sh

cat $GRAVITY_HOME_DIR/signing.key
cat $GRAVITY_HOME_DIR/tmkms.toml
cat $GRAVITY_HOME_DIR/signing.key
cat $GRAVITY_HOME_DIR/secret_connection.key