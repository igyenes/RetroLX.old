#!/bin/bash

git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2021.07
cd u-boot
make orangepi_plus2e_defconfig
ARCH=arm CROSS_COMPILE=/h3/host/bin/arm-buildroot-linux-gnueabihf- make -j$(nproc)
mkdir -p ../../uboot-orangepi-plus2e
cp u-boot-sunxi-with-spl.bin ../../uboot-orangepi-plus2e/