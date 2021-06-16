#!/bin/bash
set -eu

CHAIN_ID="gravity-testnet"
TMKMS_CONFIG_DIR=/home/tmkms

mkdir $TMKMS_CONFIG_DIR
cd $TMKMS_CONFIG_DIR
tmkms init $TMKMS_CONFIG_DIR
# TODO replace generated file to file with correct config
cat $TMKMS_CONFIG_DIR/tmkms.toml

tmkms start