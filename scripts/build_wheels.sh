#!/bin/bash
# Build utm python wheels

set -e

ARGS=($@)
VERSION=$1

PYTHON_VERSIONS="cp35-cp35m cp36-cp36m cp37-cp37m cp38-cp38"
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
export PATH=/opt/python/cp38-cp38/bin:$PATH

echo "Build utm..."
rm -rf utm-$VERSION
git clone $UTM_URL utm-$VERSION
cd utm-$VERSION
git checkout utm_$VERSION
make clean
make dist-clean
make genxsd
make all CPPFLAGS='-DNDEBUG -DSWIG'
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
  echo "Build $MODULE wheels..."
  rm -rf $MODULE
  git clone $MODULES_BASE_URL/$MODULE.git $MODULE
  cd $MODULE
  git checkout $VERSION
  for PYTHON_VERSION in $PYTHON_VERSIONS
  do
    /opt/python/$PYTHON_VERSION/bin/pip wheel . -w ./wheelhouse
  done
  echo "Repair $MODULE wheels..."
  for WHEEL in ./wheelhouse/*.whl
  do
    auditwheel repair $WHEEL -w /io/wheelhouse
  done
  cd ..
done

echo "Done."

exit 0
