# Cosmos Master Node
## Description
- master node is a main node who will get other peer information like validator kety and gentx-{id}.json
- update genesis file and update on github so that other connected peer node can access and update their genesis file
## Details
There is 3 file Dockerfile, start.sh and update-master-node.sh
# Dockerfile
This Docker file create a docker image having validator key and genesis file
we need to pass the following argument to create docker image
- PUBLIC_IP - public ip of machine to communicate other peer and swagger apis
- GIT_HUB_USER - github user name to perform commit and push operation to github branch which is responsible for storing master node genesis file and peer node information
- GIT_HUB_PASS - github user password to perform commit and push operation to github branch which is responsible for storing master node genesis file and peer node information
- GIT_HUB_EMAIL - github user email to perform commit and push operation to github branch which is responsible for storing master node genesis file and peer node information
- GIT_HUB_BRANCH - github branch which is responsible for storing master node genesis file and peer node information

#start.sh
This file is responsible for saving master genesis file in the github repo while making docker image.

#update-master-node.sh
This file is responsible for following action
- firstly to get the peer information
- update genesis file and saving master genesis file in the github repo while making docker image so that other connected peer node can update their genesis file.
- restart the master node
