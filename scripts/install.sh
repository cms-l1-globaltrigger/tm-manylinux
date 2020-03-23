#!/bin/bash
# Build and install additional tools.

set -e

echo "Create build area..."
mkdir -p /tmp/build
cd /tmp/build

echo "Install dependecies..."
yum install -y autoconf automake make glibc-devel kernel-headers gcc gcc-c++ zlib-devel pcre-devel libffi-devel openssl openssl-devel which

echo "Install XSD..."
XSD_MAJOR=4
XSD_MINOR=0
XSD_PATCH=0
XSD_VERSION=${XSD_MAJOR}.${XSD_MINOR}.${XSD_PATCH}
curl -L https://www.codesynthesis.com/download/xsd/${XSD_MAJOR}.${XSD_MINOR}/linux-gnu/x86_64/xsd-${XSD_VERSION}-1.x86_64.rpm --output xsd-${XSD_VERSION}-1.x86_64.rpm
rpm -i ./xsd-${XSD_VERSION}-1.x86_64.rpm

echo "Install Boost..."
BOOST_MAJOR=1
BOOST_MINOR=71
BOOST_PATCH=0
BOOST_VERSION=${BOOST_MAJOR}.${BOOST_MINOR}.${BOOST_PATCH}
BOOST_TAG=${BOOST_MAJOR}_${BOOST_MINOR}_${BOOST_PATCH}
curl -L https://dl.bintray.com/boostorg/release/${BOOST_VERSION}/source/boost_${BOOST_TAG}.tar.gz --output boost_${BOOST_TAG}.tar.gz
tar xzf boost_${BOOST_TAG}.tar.gz
cd boost_${BOOST_TAG}
./bootstrap.sh --without-libraries=python
./b2 --with-filesystem --with-system
./b2 install
cd ..

echo "Install Xerces-C..."
XERCES_VERSION=3.2.2
curl -L https://github.com/apache/xerces-c/archive/v${XERCES_VERSION}.tar.gz --output xerces-c-${XERCES_VERSION}.tar.gz
tar xzf xerces-c-${XERCES_VERSION}.tar.gz
cd  xerces-c-${XERCES_VERSION}
./reconf
./configure
make
make install
cd ..

echo "Install SWIG..."
SWIG_VERSION=4.0.1
curl -L https://github.com/swig/swig/archive/rel-${SWIG_VERSION}.tar.gz --output swig-rel-${SWIG_VERSION}.tar.gz
tar xzf swig-rel-${SWIG_VERSION}.tar.gz
cd swig-rel-${SWIG_VERSION}
./autogen.sh
./configure
make
make install
cd ..

echo "Clean up..."
cd /
rm -rf /tmp/build
