#!/bin/bash
# Build utm python wheels

set -e

ARGS=($@)
VERSION=$1

PYTHON_VERSIONS="cp36-cp36m cp37-cp37m cp38-cp38 cp39-cp39"
UTM_URL="https://gitlab.cern.ch/cms-l1t-utm/utm.git"
MODULES_BASE_URL="https://github.com/cms-l1-globaltrigger"

function usage() {
  echo "usage: $0 [version] [module ...]"
}

if [ ! -n "$VERSION" ]; then
  usage
  exit 1
fi

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

# Makefile requires python >= 2.7
export PATH=/opt/python/cp39-cp39/bin:$PATH

echo "Clone utm $VERSION..."
rm -rf utm-$VERSION
git clone $UTM_URL utm-$VERSION -b utm_$VERSION
cd utm-$VERSION
echo "Configure utm..."
./configure
make clean
make dist-clean
make genxsd
echo "Build utm..."
make all CPPFLAGS='-DNDEBUG -DSWIG'
echo "Setup utm..."
export UTM_ROOT=$(pwd)
export UTM_XSD_DIR=$UTM_ROOT/tmXsd
export LC_ALL="en_US.UTF-8"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$UTM_ROOT/tmUtil
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$UTM_ROOT/tmXsd
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$UTM_ROOT/tmGrammar
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$UTM_ROOT/tmTable
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$UTM_ROOT/tmEventSetup
# make test # TODO with gcc 4.8 boost unittest 1.71 BOOST_CHECK_EQUAL_COLLECTIONS fails
cd ..

for MODULE in ${ARGS[@]:1}
do
  echo "Build $MODULE $VERSION wheels..."
  rm -rf $MODULE
  git clone $MODULES_BASE_URL/$MODULE.git $MODULE
  cd $MODULE
  git checkout $VERSION
  for PYTHON_VERSION in $PYTHON_VERSIONS
  do
    /opt/python/$PYTHON_VERSION/bin/pip wheel . -w ./wheelhouse
  done
  echo "Repair $MODULE $VERSION wheels..."
  for WHEEL in ./wheelhouse/*.whl
  do
    auditwheel repair $WHEEL -w /io/wheelhouse
  done
  cd ..
done

echo "Done."

exit 0
