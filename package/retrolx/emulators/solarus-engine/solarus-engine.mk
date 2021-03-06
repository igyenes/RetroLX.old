################################################################################
#
# solarus-engine
#
################################################################################
# Version.: Release 1.6.5
SOLARUS_ENGINE_VERSION = db39983ae2bec23b9f7384323c5e2cfb77bdfbfa
SOLARUS_ENGINE_SITE = https://gitlab.com/solarus-games/solarus
SOLARUS_ENGINE_SITE_METHOD=git

SOLARUS_ENGINE_LICENSE = GPL-3.0 (code), CC-BY-SA-4.0 (Solarus logos and icons), \
	CC-BY-SA-3.0 (GUI icons)
SOLARUS_ENGINE_LICENSE_FILES = license.txt

# Install libsolarus.so
SOLARUS_ENGINE_INSTALL_STAGING = YES

SOLARUS_ENGINE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/solarus
SOLARUS_ENGINE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/solarus
SOLARUS_ENGINE_PREFIX_DIR = /opt/retrolx/solarus$(SOLARUS_ENGINE_PKG_INSTALL_DIR)

SOLARUS_ENGINE_DEPENDENCIES = glm libmodplug libogg libvorbis openal physfs \
	sdl2 sdl2_image sdl2_ttf

# Disable launcher GUI (requires Qt5)
SOLARUS_ENGINE_CONF_OPTS = \
	-DSOLARUS_GUI=OFF \
	-DSOLARUS_TESTS=OFF

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
SOLARUS_ENGINE_DEPENDENCIES += libgl
else
ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
SOLARUS_ENGINE_DEPENDENCIES += libgles
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_GL_ES=ON
endif
endif

SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_BASE_WRITE_DIR=/userdata/saves
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_WRITE_DIR=solarus

ifeq ($(BR2_aarch64),y) # https://github.com/kubernetes/ingress-nginx/issues/2802
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_USE_LUAJIT=OFF
SOLARUS_ENGINE_DEPENDENCIES += lua
else
ifeq ($(BR2_PACKAGE_LUAJIT),y)
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_USE_LUAJIT=ON
SOLARUS_ENGINE_DEPENDENCIES += luajit
else
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_USE_LUAJIT=OFF
SOLARUS_ENGINE_DEPENDENCIES += lua
endif
endif

# Install into package prefix
SOLARUS_ENGINE_INSTALL_TARGET_OPTS = DESTDIR="$(SOLARUS_ENGINE_PKG_DIR)$(SOLARUS_ENGINE_PKG_INSTALL_DIR)" install

define SOLARUS_ENGINE_MAKEPKG

	# Cleanup package first
	mv $(SOLARUS_ENGINE_PKG_DIR)$(SOLARUS_ENGINE_PKG_INSTALL_DIR)/usr/bin/solarus-run $(SOLARUS_ENGINE_PKG_DIR)$(SOLARUS_ENGINE_PKG_INSTALL_DIR)
	mv $(SOLARUS_ENGINE_PKG_DIR)$(SOLARUS_ENGINE_PKG_INSTALL_DIR)/usr/lib/* $(SOLARUS_ENGINE_PKG_DIR)$(SOLARUS_ENGINE_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/solarus-engine/*.py $(SOLARUS_ENGINE_PKG_DIR)$(SOLARUS_ENGINE_PKG_INSTALL_DIR)
	rm -Rf $(SOLARUS_ENGINE_PKG_DIR)$(SOLARUS_ENGINE_PKG_INSTALL_DIR)/usr

	# Build Pacman package
	cd $(SOLARUS_ENGINE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/solarus-engine/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

SOLARUS_ENGINE_POST_INSTALL_TARGET_HOOKS = SOLARUS_ENGINE_MAKEPKG

$(eval $(cmake-package))
