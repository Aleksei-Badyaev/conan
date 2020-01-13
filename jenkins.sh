#!/bin/bash
# Run tests in Jenkins environment.

pip install -e .[dev]

# Run tests.
# nosetests --where=conans/test --with-xunit

# Build distro images.
mv setup.py setup.py.bak
mv setup_deb.py setup.py
python setup.py --command-packages=stdeb3.command bdist_deb
mv setup.py setup_deb.py
mv setup.py.bak setup.py
rm ./*.tar.gz

python setup.py bdist_wheel

mkdir -p build/
VERSION=$(python setup.py --version)
echo "${VERSION}" > ./VERSION

sed\
 -e "s/VERSION/${VERSION}/g"\
 -e "s%BRANCH%$(git rev-parse --abbrev-ref HEAD | sed -e 's%/%-%g')%g"\
  artifactory.json > build/artifactory.json
