# ----------------- Module builder -----------------
FROM golang:1.16-alpine AS grativy-module-build-env

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3

RUN apk add --no-cache $PACKAGES

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge/

# clone the repo
RUN git clone https://github.com/onomyprotocol/gravity-bridge.git $GRAVITY_DIR

# set working dir
WORKDIR $GRAVITY_DIR/module

# Build gravity artifact
RUN make build-linux

# ----------------- Tendermint harness builder -----------------
FROM golang:1.16-alpine AS tm-signer-harness-build-env

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3

RUN apk add --no-cache $PACKAGES

ARG TENDERMIN_DIR=/go/src/github.com/tendermint/tendermint/

# clone the repo
RUN git clone https://github.com/tendermint/tendermint.git $TENDERMIN_DIR

# set working dir
WORKDIR $TENDERMIN_DIR/tools/tm-signer-harness

# Build gravity artifact
RUN make build

# ----------------- Module runner -----------------
# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --update ca-certificates

WORKDIR /root

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge/
# Copy over binaries from the rativy-module-build-env
COPY --from=grativy-module-build-env $GRAVITY_DIR/module/build/gravity /usr/bin/gravity

ARG TENDERMIN_DIR=/go/src/github.com/tendermint/tendermint/
# Copy over binaries from the tendermint/tm-signer-harness
COPY --from=tm-signer-harness-build-env $TENDERMIN_DIR/build/tm-signer-harness /usr/bin/tm-signer-harness

WORKDIR ~/

COPY . .

RUN /bin/sh bootstrap_gravity.sh

RUN /bin/sh generate_tmkms_files.sh

RUN ls

CMD ["gravity"]
