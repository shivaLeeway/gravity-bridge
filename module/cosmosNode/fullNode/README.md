# Full Node

Here we'll se how you can create a full node and connect it with the gravity-testnet.

## Docker File

This docker file is used to create  docker image which when run can start a peer validator node.


## start.sh

Currently we are running this file after going inside our container, it clones the config branch which holds a folder having genesis.json file and seed file which holds the peer info than it change that genesis file with full-node genesis file and add seed info to full node. 



