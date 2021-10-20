#!/bin/sh

set -e

usage()
{
  echo "Usage: $0"
  exit 2
}

test $# = 0 || usage

if test "`uname`" = "Linux"
then
  OS=Linux
else
  OS=MacOSX
fi

# install constructor
wget -c --no-check-certificate https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-${OS}-x86_64.sh -P /tmp
rm -rf /tmp/miniforge
bash /tmp/Miniforge3-${OS}-x86_64.sh -b -p /tmp/miniforge
export PATH="/tmp/miniforge/bin:$PATH"
conda install -y constructor

# build
rm -f otconda*.sh
constructor -v otconda

# test
rm -rf /tmp/otconda
bash otconda*.sh -b -p /tmp/otconda
PATH="/tmp/otconda/bin:$PATH"
python test_bundle.py
