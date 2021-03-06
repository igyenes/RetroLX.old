################################################################################
#
# RetroFE frontend
#
################################################################################
# Version.: Commits on Sep 11, 2021
RETROFE_VERSION = 2bf2cfa368e1d618a752612d41c5c52989b10ec9
RETROFE_SITE = https://github.com/phulshof/RetroFE
RETROFE_SITE_METHOD=git
RETROFE_LICENSE = GPLv3
RETROFE_DEPENDENCIES = sdl2 sdl2_image sdl2_mixer sdl2_ttf gstreamer1 gst1-plugins-base

RETROFE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/retrofe
RETROFE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/retrofe

RETROFE_SUBDIR = RetroFE/Source
#RETROFE_CONF_OPTS = 
#-DBUILD_SHARED_LIBS=OFF

define RETROFE_INSTALL_TARGET_CMDS
	cd $(@D) && $(HOST_DIR)/bin/python $(@D)/Scripts/Package.py --os=linux --build=full
endef

define RETROFE_MAKEPKG
	# Create directories
	mkdir -p $(RETROFE_PKG_DIR)$(RETROFE_PKG_INSTALL_DIR)

	# Copy package files
	cp -R $(@D)/Artifacts/linux/RetroFE/* $(RETROFE_PKG_DIR)$(RETROFE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(RETROFE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/retrofe/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

RETROFE_POST_INSTALL_TARGET_HOOKS = RETROFE_MAKEPKG

$(eval $(cmake-package))
