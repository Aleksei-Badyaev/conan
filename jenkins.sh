#!/bin/bash
# Run tests in Jenkins environment.

pip install -e .[dev]

# Run tests.
nosetests --where=conans/test --with-xunit

# Build distro images.
/bin/bash clean.sh
python setup.py --command-packages=stdeb3.command bdist_deb
rm ./*.tar.gz
python setup.py bdist_wheel
mkdir -p build/
VERSION=$(python setup.py --version)
echo "${VERSION}" > ./VERSION
sed\
 -e "s/VERSION/${VERSION}/g"\
 -e "s%BRANCH%$(git rev-parse --abbrev-ref HEAD | sed -e 's%/%-%g')%g"\
  artifactory.json > build/artifactory.json
