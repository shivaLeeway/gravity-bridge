# ----------------- Module builder -----------------
FROM golang:1.16-alpine AS build-env

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3 git

RUN apk add --no-cache $PACKAGES

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge/

# clone the repo
RUN git clone https://github.com/onomyprotocol/gravity-bridge.git $GRAVITY_DIR

# set working dir
WORKDIR $GRAVITY_DIR/module

# Build gravity artifact
RUN make build-linux

RUN ls build

# ----------------- Module runner -----------------

# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --update ca-certificates
WORKDIR /root

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge/

# Copy over binaries from the build-env
COPY --from=build-env $GRAVITY_DIR/module/build/gravity /usr/bin/gravity

ARG CHAIN_ID="gravity-testnet"
ARG KEYRING="--keyring-backend test"

# init one validator
RUN gravity init --chain-id=$CHAIN_ID validator1
RUN gravity keys add validator1 $KEYRING
RUN gravity add-genesis-account $(gravity keys show validator1 -a $KEYRING) 10000000nom
RUN gravity eth_keys add --output=text --dry-run=true | grep address: | sed 's/address://g' > eth_key
RUN gravity gentx validator1 10000000nom $(cat eth_key) $(gravity keys show validator1 -a $KEYRING) --chain-id $CHAIN_ID $KEYRING
RUN gravity collect-gentxs

## Run gravity
CMD ["gravity"]
