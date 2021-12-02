#!/bin/bash

set -e

BOOST_MAJOR=1
BOOST_MINOR=77
BOOST_PATCH=0

BOOST_VERSION=${BOOST_MAJOR}.${BOOST_MINOR}.${BOOST_PATCH}
BOOST_TAG=${BOOST_MAJOR}_${BOOST_MINOR}_${BOOST_PATCH}
SWIG_BUILD_AREA=/tmp/build_boost

echo "Create Boost build area..."
mkdir -p ${SWIG_BUILD_AREA}
cd ${SWIG_BUILD_AREA}

echo "Download Boost..."
curl -L https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_TAG}.tar.gz --output boost_${BOOST_TAG}.tar.gz
echo "Extract Boost..."
tar xzf boost_${BOOST_TAG}.tar.gz
cd boost_${BOOST_TAG}
echo "Configure Boost..."
./bootstrap.sh --without-libraries=python
echo "Build Boost..."
./b2 --with-filesystem --with-system
echo "Install Boost..."
./b2 install

echo "Clean up Boost..."
cd /
rm -rf ${SWIG_BUILD_AREA}
