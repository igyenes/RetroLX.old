################################################################################
#
# Cemutil
#
################################################################################

CEMUTIL_VERSION = 5ae1f324fd9c9328046c2f295608bf72c11e62a0
CEMUTIL_SOURCE = sharedFonts.zip
CEMUTIL_SITE = https://github.com/CEMULinux/cemutil/raw/$(CEMUTIL_VERSION)

define CEMUTIL_EXTRACT_CMDS
	mkdir -p $(@D) && cd $(@D) && unzip -x $(DL_DIR)/$(CEMUTIL_DL_SUBDIR)/$(CEMUTIL_SOURCE)
endef

define CEMUTIL_INSTALL_TARGET_CMDS
	mkdir -p $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)
	cp -prn $(@D)/sharedFonts $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)
endef

$(eval $(generic-package))
