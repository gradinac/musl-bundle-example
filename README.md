## Musl Bundle Example
For the purposes of using the libc selection flag when compiling a native-image using [GraalVM](https://www.graalvm.org/), you will (for GraalVM 20.0) need a library bundle.

This bundle should contain the following static libraries:
 - libmusl
 - zlib
 - libstdc++

The goal of this repository is to create such a bundle.

## Requirements
The only requirement is Docker. Since the build is entirely containerized, you will need a Linux-AMD64 system with Docker installed.

## How To Use
Run the `create_bundle.sh` script. The resulting `musl.tar.gz` bundle will be placed in the `bundle` folder. To use the bundle, extract it to a directory of your choice and use the resulting path as the libc option argument.