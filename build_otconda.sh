#!/bin/sh

set -e

usage()
{
  echo "Usage: $0 PY_MAJOR_VER"
  exit 2
}

test $# = 1 || usage

PY_MAJOR_VER=$1

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

# https://github.com/conda/constructor/issues/204
conda install -y conda=4.3

# build
rm -f otconda${PY_MAJOR_VER}*.sh
sed "s|@PY_MAJOR_VER@|${PY_MAJOR_VER}|g" construct.yaml.in > construct.yaml
constructor -v .

# test
rm -rf /tmp/otconda
bash otconda${PY_MAJOR_VER}*.sh -b -p /tmp/otconda
PATH="/tmp/otconda/bin:$PATH"
python otconda_test.py
