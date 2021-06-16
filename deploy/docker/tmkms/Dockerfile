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

# ----------------- Module runner -----------------

# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --update ca-certificates
WORKDIR /root

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/gravity-bridge/

# Copy over binaries from the build-env
COPY --from=build-env $GRAVITY_DIR/module/build/gravity /usr/bin/gravity

WORKDIR ~/

RUN pwd

COPY . .

RUN /bin/sh bootstrap_gravity.sh

CMD ["gravity"]
