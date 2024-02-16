#!/bin/bash
# Build utm python wheels

set -e

ARGS=($@)
VERSION=$1
MODULES=${ARGS[@]:1}

PYTHON_VERSIONS=${PYTHON_VERSIONS:-"cp36-cp36m cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310 cp311-cp311 cp312-cp312"}
UTM_URL=${UTM_URL:-"https://gitlab.cern.ch/cms-l1t-utm/utm.git"}
MODULES_BASE_URL=${MODULES_BASE_URL:-"https://github.com/cms-l1-globaltrigger"}

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

# Makefile (<=0.8.x) requires python >= 2.7
export PATH=/opt/python/cp39-cp39/bin:$PATH

echo "Clone utm $VERSION..."
UTM_TAG=${UTM_TAG:-"utm_$VERSION"}
UTM_DIR="utm-$VERSION"
rm -rf $UTM_DIR
git clone $UTM_URL $UTM_DIR -b $UTM_TAG
cd $UTM_DIR
echo "Configure utm..."
# Backward compatibility utm < 0.9
if [ -f configure ]; then
  ./configure
fi
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
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
make test CPPFLAGS='-DNDEBUG -DSWIG'
cd ..

for MODULE in ${MODULES}
do
  echo "Build $MODULE $VERSION wheels..."
  rm -rf $MODULE
  git clone $MODULES_BASE_URL/$MODULE.git -b $VERSION $MODULE
  cd $MODULE
  for PYTHON_VERSION in $PYTHON_VERSIONS
  do
    /opt/python/$PYTHON_VERSION/bin/python -m pip wheel . -w ./wheelhouse
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
