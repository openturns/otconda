#!/bin/sh

set -e

usage()
{
  echo "Usage: $0 PY_MAJOR_VER OS"
  exit 2
}

test $# = 2 || usage

PY_MAJOR_VER=$1
OS=$2

# install constructor
wget -c --no-check-certificate https://repo.continuum.io/miniconda/Miniconda${PY_MAJOR_VER}-latest-${OS}-x86_64.sh -P /tmp
rm -rf /tmp/miniconda
bash /tmp/Miniconda${PY_MAJOR_VER}-latest-${OS}-x86_64.sh -b -p /tmp/miniconda
PATH="/tmp/miniconda/bin:$PATH"
conda install -y constructor
conda install -y conda=4.3  # pin conda to fix pyqt resolve

# build
sed "s|@PY_MAJOR_VER@|${PY_MAJOR_VER}|g" construct.yaml.in > construct.yaml
constructor .

# test
rm -rf /tmp/otconda
bash otconda${PY_MAJOR_VER}*.sh -b -p /tmp/otconda
PATH="/tmp/otconda/bin:$PATH"
python otconda_test.py
