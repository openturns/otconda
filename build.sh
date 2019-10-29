#!/bin/sh

set -e

usage()
{
  echo "Usage: $0 PY_MAJOR_VER PY_MINOR_VER"
  exit 2
}

test $# = 2 || usage

PY_MAJOR_VER=$1
PY_MINOR_VER=$2

if test "`uname`" = "Linux"
then
  OS=Linux
else
  OS=MacOSX
fi

# install constructor
wget -c --no-check-certificate https://repo.continuum.io/miniconda/Miniconda${PY_MAJOR_VER}-latest-${OS}-x86_64.sh -P /tmp
rm -rf /tmp/miniconda
bash /tmp/Miniconda${PY_MAJOR_VER}-latest-${OS}-x86_64.sh -b -p /tmp/miniconda
PATH="/tmp/miniconda/bin:$PATH"
conda install -y constructor

# build
rm -f otconda${PY_MAJOR_VER}*.sh
sed -e "s|@PY_MAJOR_VER@|${PY_MAJOR_VER}|g" -e "s|@PY_MINOR_VER@|${PY_MINOR_VER}|g" otconda/construct.yaml.in > otconda/construct.yaml
constructor -v otconda

# test
rm -rf /tmp/otconda
bash otconda${PY_MAJOR_VER}*.sh -b -p /tmp/otconda
PATH="/tmp/otconda/bin:$PATH"
python test_bundle.py
