################################################################################
#
# evsieve
#
################################################################################

EVSIEVE_VERSION = v1.2.0
EVSIEVE_SOURCE = foo-$(EVSIEVE_VERSION).tar.gz
EVSIEVE_SITE = $(call github,KarsMulder,evsieve,$(EVSIEVE_VERSION))
EVSIEVE_LICENSE = GPLv2
EVSIEVE_LICENSE_FILES = COPYING

EVSIEVE_DEPENDENCIES = host-rustc

EVSIEVE_CARGO_ENV = CARGO_HOME=$(HOST_DIR)/share/cargo

EVSIEVE_BIN_DIR = target/$(RUSTC_TARGET_NAME)/$(EVSIEVE_CARGO_MODE)

EVSIEVE_CARGO_OPTS = \
 	$(if $(BR2_ENABLE_DEBUG),,--release) \
 	--target=$(RUSTC_TARGET_NAME) \
 	--manifest-path=$(@D)/Cargo.toml

define EVSIEVE_BUILD_CMDS
 	$(TARGET_MAKE_ENV) $(EVSIEVE_CARGO_ENV) \
 		cargo build $(EVSIEVE_CARGO_OPTS)
endef

define EVSIEVE_INSTALL_TARGET_CMDS
 	$(INSTALL) -D -m 0755 $(@D)/$(EVSIEVE_BIN_DIR)release/evsieve \
 		$(TARGET_DIR)/usr/bin/evsieve
	$(TARGET_STRIP) -s $(TARGET_DIR)/usr/bin/evsieve
endef

$(eval $(generic-package))
