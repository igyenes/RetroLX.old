#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/atf/sun50i_h6/bl31.bin"

# Crust firmware (optional)
export SCP="/dev/null"

# U-Boot version
export UBOOT_VERSION="v2021.01"
#not working so far export UBOOT_VERSION="v2021.10"

# Clone U-Boot specified version
wget "https://ftp.denx.de/pub/u-boot/u-boot-2021.01.tar.bz2"
tar xf u-boot-2021.01.tar.bz2
cd u-boot-2021.01

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make orangepi_one_plus_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
mkdir -p ../../uboot-orangepi-one-plus

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-orangepi-one-plus/
