#!/bin/sh
# This script builds the bundle inside the Docker container and then copies it to the host machine.

set -e
# Set up the URL to the version of musl used by alpine at the time of writing.
LATEST_MUSL_URL="https://musl.libc.org/releases/musl-1.1.22.tar.gz"
# Set up the URL for the latest zlib version available at the time of writing.
LATEST_ZLIB_URL="https://www.zlib.net/zlib-1.2.11.tar.gz"
BUNDLE_DIR_NAME="bundle"
BUILD_DIR="/build"
BUNDLE_DIR="${BUILD_DIR}/${BUNDLE_DIR_NAME}"

# Create the folder that will contain the finished bundle.
cd /build

echo "Downloading musl library."
wget "${LATEST_MUSL_URL}"
echo "Downloading zlib library."
wget "${LATEST_ZLIB_URL}"
# Grab the names of the archives from the URL.
MUSL_TAR="${LATEST_MUSL_URL##*/}"
ZLIB_TAR="${LATEST_ZLIB_URL##*/}"

# Compile musl, compiling only the static musl libraries.
echo "Extracting musl."
tar xvzf "$MUSL_TAR"
MUSL_DIR=$(tar tzf "${MUSL_TAR}" | cut -d'/' -f1 | uniq)
cd "${MUSL_DIR}"
echo "Configuring musl."
./configure --prefix="${BUNDLE_DIR}" --disable-shared --enable-wrapper
echo "Building musl"
make && make install
cd ..

# Compile zlib with the musl library we just built.
export CC="${BUNDLE_DIR}/bin/musl-gcc"

echo "Extracting zlib."
tar xvzf "${ZLIB_TAR}"
ZLIB_DIR=$(tar tzf "${ZLIB_TAR}" | cut -d'/' -f1 | uniq)
cd "${ZLIB_DIR}"
echo "Configuring zlib."
./configure --static --prefix="${BUNDLE_DIR}"
echo "Building zlib."
make libz.a && make install
cd ..

# There are multiple ways to obtain libc++.a:
#   - compile gcc and rip it from the resulting artifacts
#   - use libc++.a from alpine's gcc
#   - obtain from source packages. ( E.G. libstdc++-9-dev ) 
# We will take the second approach here.

cp /usr/lib/libstdc++.a "${BUNDLE_DIR}/lib"

cd "${BUILD_DIR}"

rm -rf "${BUNDLE_DIR}/bin/" "${BUNDLE_DIR}/share/"
tar cvzf "${BUNDLE_RES_DIR}/musl.tar.gz" "${BUNDLE_DIR_NAME}"/*
