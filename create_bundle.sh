#!/bin/bash
# This script runs the docker container that creates the bundle.

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
cd "${SCRIPT_PATH}"
export BUNDLE_RES_DIR=/build/result
rm -rf bundle
mkdir bundle
docker build . -t musl-bundle-example-builder
docker run --entrypoint /build/build.sh -v $(pwd)/bundle:${BUNDLE_RES_DIR} -e BUNDLE_RES_DIR musl-bundle-example-builder