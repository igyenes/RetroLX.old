################################################################################
#
# BEETLE_SUPERGRAFX
#
################################################################################
# Version.: Commits on Apr 12, 2021
LIBRETRO_BEETLE_SUPERGRAFX_VERSION = 7a84c5e3b9e0dc44266d3442130296888f3c573a
LIBRETRO_BEETLE_SUPERGRAFX_SITE = $(call github,libretro,beetle-supergrafx-libretro,$(LIBRETRO_BEETLE_SUPERGRAFX_VERSION))
LIBRETRO_BEETLE_SUPERGRAFX_LICENSE = GPLv2

LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_SUPERGRAFX_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-beetle-supergrafx

define LIBRETRO_BEETLE_SUPERGRAFX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_SUPERGRAFX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR)$(LIBRETRO_BEETLE_SUPERGRAFX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_supergrafx_libretro.so \
	$(LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR)$(LIBRETRO_BEETLE_SUPERGRAFX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-beetle-supergrafx/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_SUPERGRAFX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_SUPERGRAFX_MAKEPKG

$(eval $(generic-package))