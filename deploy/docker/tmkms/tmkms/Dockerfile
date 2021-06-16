# ----------------- KMS builder -----------------
FROM centos:7 AS tmkms-build-env

RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
    centos-release-scl \
    cmake \
    epel-release \
    libudev-devel \
    libusbx-devel \
    openssl-devel \
    sudo && \
    yum install -y --enablerepo=epel libsodium-devel && \
    yum install -y --enablerepo=centos-sclo-rh llvm-toolset-7 && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV LD_LIBRARY_PATH=/opt/rh/llvm-toolset-7/root/usr/lib64
ENV PATH "/opt/rh/llvm-toolset-7/root/usr/bin:/opt/rh/llvm-toolset-7/root/usr/sbin:$PATH"
ENV PKG_CONFIG_PATH=/opt/rh/llvm-toolset-7/root/usr/lib64/pkgconfig
ENV X_SCLS llvm-toolset-7

# Create "developer" user
RUN useradd developer && \
    echo 'developer ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/developer

# Switch to the "developer" user
USER developer
ARG TMKMS_DIR=/home/developer
WORKDIR $TMKMS_DIR

# Include cargo in the path
ENV PATH "$PATH:/home/developer/.cargo/bin"

# Install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    rustup update && \
    rustup component add rustfmt && \
    rustup component add clippy && \
    cargo install cargo-audit

# clone the repo
# TODO cahnge to onomy
RUN git clone https://github.com/iqlusioninc/tmkms.git $TMKMS_DIR/tmkms

# set working dir
WORKDIR $TMKMS_DIR/tmkms

# Build tmkms artifact
RUN cargo build --features=ledger --release --bin tmkms

RUN ls /home/developer/tmkms/target/release

# ----------------- KMS runner -----------------

FROM centos:7

COPY --from=tmkms-build-env /home/developer/tmkms/target/release/tmkms /usr/local/bin

COPY . .

RUN /bin/sh bootstrap_tmkms.sh

CMD ["tmkms"]