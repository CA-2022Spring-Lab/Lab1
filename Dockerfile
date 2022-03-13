FROM hoshinotouko/riscv-toolchain-basement:debian-buster

ENV DEBIAN_FRONTEND noninteractive
# ENV ORB_PORT=10000
# ENV TANGO_HOST=127.0.0.1:${ORB_PORT}
# ENV HOME=/workshop

RUN set -ex

RUN apt update
RUN apt install -y sudo git
RUN apt install -y tango-common
RUN apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
RUN apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev

RUN apt install -y gcc g++ python3-pip python3-dev python3-setuptools

# dirs
# WORKDIR $HOME/source

# riscv-gnu-tools
# RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain.git
WORKDIR $HOME/source/riscv-gnu-toolchain

# RUN ./configure --prefix=$HOME/riscv --with-arch=rv32gc --with-abi=ilp32d
# RUN ./configure --prefix=$HOME/riscv --enable-multilib
RUN ./configure --prefix=$HOME/riscv --with-arch=rv64i
RUN make -j$(nproc) SIM=qemu

ENV PATH="$HOME/riscv/bin:$PATH"

# riscv-toolchain
# WORKDIR $HOME/source
# RUN git clone --recursive https://github.com/riscv/riscv-tools
# WORKDIR $HOME/source/riscv-tools
# ENV RISCV=$HOME/riscv/toolchain
# RUN ./build-spike-pk.sh
# # RUN ./build-rv32ima.sh

# ENV PATH="$HOME/riscv/toolchain/bin:$PATH"
# ENV PATH="$HOME/riscv/toolchain/riscv64-unknown-elf/bin:$PATH"

# qemu

RUN mkdir -p $HOME/riscv/qemu
RUN apt install -y ninja-build libglib2.0-dev pkg-config libmount-dev libpixman-1-dev
WORKDIR $HOME/source/riscv-gnu-toolchain/qemu
RUN ./configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/workshop/riscv/qemu
RUN make -j$(nproc)
RUN make install

ENV PATH="$HOME/riscv/qemu/bin:$PATH"

RUN mkdir -p $HOME/src
WORKDIR $HOME/src

CMD ["bash"]
