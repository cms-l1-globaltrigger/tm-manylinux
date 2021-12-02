#!/bin/bash

set -e

XSD_MAJOR=4
XSD_MINOR=0
XSD_PATCH=0

XSD_VERSION=${XSD_MAJOR}.${XSD_MINOR}.${XSD_PATCH}
XSD_BUILD_AREA=/tmp/build_xsd

echo "Create XSD build area..."
mkdir -p ${XSD_BUILD_AREA}
cd ${XSD_BUILD_AREA}

echo "Download XSD..."
curl -L https://www.codesynthesis.com/download/xsd/${XSD_MAJOR}.${XSD_MINOR}/linux-gnu/x86_64/xsd-${XSD_VERSION}-1.x86_64.rpm --output xsd-${XSD_VERSION}-1.x86_64.rpm
echo "Install XSD..."
rpm -i ./xsd-${XSD_VERSION}-1.x86_64.rpm

echo "Clean up XSD..."
cd /
rm -rf ${XSD_BUILD_AREA}
