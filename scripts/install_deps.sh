#!/bin/bash

set -e

echo "Install dependecies..."
yum install -y \
autoconf \
automake \
make \
glibc-devel \
kernel-headers \
gcc \
gcc-c++ \
zlib-devel \
pcre-devel \
libffi-devel \
openssl \
openssl-devel \
which
