#!/bin/bash
# Jenkins build script.

mv setup.py setup.py.bak
mv setup_deb.py setup.py

pip install -e .
VERSION=$(python setup.py --version)
PACKAGE_NAME="conan"
PACKAGE_FILE="${PACKAGE_NAME}_${VERSION}-1"

# Build distro images.
pip install stdeb3
python setup.py --command-packages=stdeb3.command bdist_deb
rm -f ./*.tar.gz
pushd "deb_dist/${PACKAGE_NAME}-${VERSION}"
PYBUILD_DISABLE=test dpkg-buildpackage -uc -us
popd

mv setup.py setup_deb.py
mv setup.py.bak setup.py
python setup.py bdist_wheel

mkdir -p build/
echo "${VERSION}" > ./VERSION
sed\
 -e "s/VERSION/${VERSION}/g"\
 -e "s%BRANCH%$(git rev-parse --abbrev-ref HEAD | sed -e 's%/%-%g')%g"\
  artifactory.json > build/artifactory.json
