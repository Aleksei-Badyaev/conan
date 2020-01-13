#!/bin/bash

# Build distro images.
mv setup.py setup.py.bak
mv setup_deb.py setup.py
pip install -e .[dev]
python setup.py --command-packages=stdeb3.command bdist_deb
rm -f ./*.tar.gz
mv setup.py setup_deb.py
mv setup.py.bak setup.py

mkdir -p build/
VERSION=$(python setup.py --version)
echo "${VERSION}" > ./VERSION

sed\
 -e "s/VERSION/${VERSION}/g"\
 -e "s%BRANCH%$(git rev-parse --abbrev-ref HEAD | sed -e 's%/%-%g')%g"\
  artifactory.json > build/artifactory.json
