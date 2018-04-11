#!/bin/sh

set -e

PY_MAJOR_VER=3

wget -c --no-check-certificate https://repo.continuum.io/miniconda/Miniconda${PY_MAJOR_VER}-latest-Linux-x86_64.sh -P /tmp
rm -rf $HOME/miniconda $HOME/.condarc
bash /tmp/Miniconda${PY_MAJOR_VER}-latest-Linux-x86_64.sh -b -p $HOME/miniconda
PATH="$HOME/miniconda/bin:$PATH"
conda install -y constructor

sed "s|@PY_MAJOR_VER@|${PY_MAJOR_VER}|g" construct.yaml.in > construct.yaml
constructor .

rm -rf $HOME/otconda
bash otconda${PY_MAJOR_VER}*.sh -b -p $HOME/otconda
PATH="$HOME/otconda/bin:$PATH"
python otconda_test.py
