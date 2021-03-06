################################################################################
#
# FBALPHA2012_CPS2
#
################################################################################
# Version.: Commits on Oct 8, 2021
LIBRETRO_FBALPHA2012_CPS2_VERSION = 03f0889eb09cdaec687c5e0c0d2ef53895e5312b
LIBRETRO_FBALPHA2012_CPS2_SITE = $(call github,libretro,fbalpha2012_cps2,$(LIBRETRO_FBALPHA2012_CPS2_VERSION))
LIBRETRO_FBALPHA2012_CPS2_LICENSE = Non-commercial

LIBRETRO_FBALPHA2012_CPS2_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FBALPHA2012_CPS2_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fbalpha2012-cps2

define LIBRETRO_FBALPHA2012_CPS2_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f makefile.libretro
endef

define LIBRETRO_FBALPHA2012_CPS2_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FBALPHA2012_CPS2_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS2_PKG_INSTALL_DIR)/bios/samples

	# Copy package files
	$(INSTALL) -D $(@D)/fbalpha2012_cps2_libretro.so $(LIBRETRO_FBALPHA2012_CPS2_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS2_PKG_INSTALL_DIR)
	#$(INSTALL) -D $(@D)/metadata/* $(LIBRETRO_FBALPHA2012_CPS2_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS2_PKG_INSTALL_DIR)/bios/
	#$(INSTALL) -D $(@D)/dats/* $(LIBRETRO_FBALPHA2012_CPS2_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS2_PKG_INSTALL_DIR)/bios/

	# Build Pacman package
	cd $(LIBRETRO_FBALPHA2012_CPS2_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fbalpha2012-cps2/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FBALPHA2012_CPS2_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FBALPHA2012_CPS2_MAKEPKG

$(eval $(generic-package))
