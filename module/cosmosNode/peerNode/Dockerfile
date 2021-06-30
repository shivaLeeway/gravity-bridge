FROM golang:1.16-alpine AS build-env

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3 git

RUN apk add --no-cache $PACKAGES

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge

# clone the repo
RUN git clone https://github.com/onomyprotocol/gravity-bridge.git $GRAVITY_DIR

# set working dir
WORKDIR $GRAVITY_DIR/module

# Build gravity artifact
RUN make build-linux

RUN ls build
# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --update ca-certificates git
WORKDIR /root

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge

# Copy over binaries from the build-env
COPY --from=build-env $GRAVITY_DIR/module/build/gravity /usr/bin/gravity
EXPOSE 26656 26657 1317 9090

ARG CHAIN_ID="gravity-testnet"
ARG KEYRING="--keyring-backend test"
ARG GRAVITY_HOST="0.0.0.0"
ARG GRAVITY_NODE_CONFIG=".gravity/config/config.toml"
ARG GRAVITY_APP_CONFIG=".gravity/config/app.toml"
ARG GIT_HUB_USER=${GIT_HUB_USER}
ARG GIT_HUB_PASS=${GIT_HUB_PASS}
ARG GIT_HUB_EMAIL=${GIT_HUB_EMAIL}
ARG GIT_REPO=${GIT_REPO}
ARG GIT_BRANCH=${GIT_BRANCH}
# init one validator
RUN gravity init --chain-id=$CHAIN_ID validator2

#RUN gravity keys add validator1 $KEYRING
RUN gravity keys add --output=json validator2 $KEYRING > validator2.json

RUN gravity add-genesis-account $(gravity keys show validator2 -a $KEYRING) 10000000stake

RUN gravity eth_keys add --output=text --dry-run=true | grep address: | sed 's/address://g' > eth_key
RUN gravity gentx validator2 10000000stake $(cat eth_key) $(gravity keys show validator2 -a $KEYRING) --chain-id $CHAIN_ID $KEYRING

# Change configuration in the toml file
RUN sed -i "s#\"tcp://127.0.0.1:26656\"#\"tcp://$GRAVITY_HOST:26656\"#g" $GRAVITY_NODE_CONFIG
RUN sed -i "s#\"tcp://127.0.0.1:26657\"#\"tcp://$GRAVITY_HOST:26657\"#g" $GRAVITY_NODE_CONFIG
RUN sed -i 's#addr_book_strict = true#addr_book_strict = false#g' $GRAVITY_NODE_CONFIG
RUN sed -i 's#external_address = ""#external_address = "tcp://'$GRAVITY_HOST:26656'"#g' $GRAVITY_NODE_CONFIG
RUN sed -i 's#enable = false#enable = true#g' $GRAVITY_APP_CONFIG
RUN sed -i 's#swagger = false#swagger = true#g' $GRAVITY_APP_CONFIG


##----------------------------- commit master genesis.json file-----
RUN git clone --single-branch --branch ${GIT_BRANCH} https://$GIT_REPO
WORKDIR /root/gravity-bridge
RUN sh module/cosmosNode/peerNode/start.sh $GIT_HUB_USER $GIT_HUB_PASS $GIT_HUB_EMAIL $GIT_REPO $GIT_BRANCH
WORKDIR /root
