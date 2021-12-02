#!/bin/bash

set -e

SWIG_MAJOR=4
SWIG_MINOR=0
SWIG_PATCH=2

SWIG_VERSION=${SWIG_MAJOR}.${SWIG_MINOR}.${SWIG_PATCH}
SWIG_BUILD_AREA=/tmp/build_swig

echo "Create SWIG build area..."
mkdir -p ${SWIG_BUILD_AREA}
cd ${SWIG_BUILD_AREA}

echo "Download SWIG..."
curl -L https://github.com/swig/swig/archive/rel-${SWIG_VERSION}.tar.gz --output swig-rel-${SWIG_VERSION}.tar.gz
echo "Extract SWIG..."
tar xzf swig-rel-${SWIG_VERSION}.tar.gz
cd swig-rel-${SWIG_VERSION}
echo "Configure SWIG..."
./autogen.sh
./configure
echo "Build SWIG..."
make
echo "Install SWIG..."
make install

echo "Clean up SWIG build area..."
cd /
rm -rf ${SWIG_BUILD_AREA}
