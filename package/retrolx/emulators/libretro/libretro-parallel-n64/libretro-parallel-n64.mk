################################################################################
#
# PARALLEL_N64
#
################################################################################
# Version.: Commits on Mar 24, 2021
LIBRETRO_PARALLEL_N64_VERSION = 0a67445ce63513584d92e5c57ea87efe0da9b3bd
LIBRETRO_PARALLEL_N64_SITE = $(call github,libretro,parallel-n64,$(LIBRETRO_PARALLEL_N64_VERSION))
LIBRETRO_PARALLEL_N64_LICENSE = GPLv2
LIBRETRO_PARALLEL_N64_DEPENDENCIES = retroarch

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	LIBRETRO_PARALLEL_N64_DEPENDENCIES += rpi-userland
endif

LIBRETRO_PARALLEL_N64_EXTRA_ARGS=
LIBRETRO_PARALLEL_N64_BOARD=

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
        LIBRETRO_PARALLEL_N64_EXTRA_ARGS=ARCH=aarch64
	LIBRETRO_PARALLEL_N64_PLATFORM=rpi4_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
	LIBRETRO_PARALLEL_N64_PLATFORM=rpi3

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
        LIBRETRO_PARALLEL_N64_PLATFORM=odroid

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
	LIBRETRO_PARALLEL_N64_PLATFORM=rpi2

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	LIBRETRO_PARALLEL_N64_PLATFORM=odroid
	LIBRETRO_PARALLEL_N64_BOARD=ODROID-XU4

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905),y)
	LIBRETRO_PARALLEL_N64_EXTRA_ARGS=FORCE_GLES=1 ARCH=aarch64
	LIBRETRO_PARALLEL_N64_PLATFORM=h5

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S912),y)
	LIBRETRO_PARALLEL_N64_EXTRA_ARGS=FORCE_GLES=1 ARCH=aarch64
	LIBRETRO_PARALLEL_N64_PLATFORM=h5

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H3),y)
        LIBRETRO_PARALLEL_N64_PLATFORM=classic_armv7_a7

# unoptimized yet
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
	LIBRETRO_PARALLEL_N64_EXTRA_ARGS=FORCE_GLES=1 ARCH=aarch64
	LIBRETRO_PARALLEL_N64_PLATFORM=h5

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
	LIBRETRO_PARALLEL_N64_EXTRA_ARGS=ARCH=x86
	LIBRETRO_PARALLEL_N64_PLATFORM=unix

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
	LIBRETRO_PARALLEL_N64_EXTRA_ARGS=ARCH=x86_64
	LIBRETRO_PARALLEL_N64_PLATFORM=unix

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
	LIBRETRO_PARALLEL_N64_PLATFORM=rockpro64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H5),y)
        LIBRETRO_PARALLEL_N64_PLATFORM=h5

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
	LIBRETRO_PARALLEL_N64_PLATFORM=n2

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
	LIBRETRO_PARALLEL_N64_PLATFORM=odroid
	LIBRETRO_PARALLEL_N64_BOARD=ODROIDGOA

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
	LIBRETRO_PARALLEL_N64_PLATFORM=imx6

else
	LIBRETRO_PARALLEL_N64_PLATFORM=$(LIBRETRO_PLATFORM)
endif

define LIBRETRO_PARALLEL_N64_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PARALLEL_N64_PLATFORM)" \
		BOARD="$(LIBRETRO_PARALLEL_N64_BOARD)" $(LIBRETRO_PARALLEL_N64_EXTRA_ARGS)
endef

define LIBRETRO_PARALLEL_N64_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/parallel_n64_libretro.so \
	$(TARGET_DIR)/usr/lib/libretro/parallel_n64_libretro.so
endef

define PARALLEL_N64_CROSS_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/Makefile
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/Makefile
endef

PARALLEL_N64_PRE_CONFIGURE_HOOKS += PARALLEL_N64_FIXUP

$(eval $(generic-package))
