################################################################################
#
# UNITV2SUPPORT
#
################################################################################

UNITV2SUPPORT_VERSION = 0
UNITV2SUPPORT_SITE = $(BR2_EXTERNAL_UNITV2_PATH)/package/unitv2support
UNITV2SUPPORT_SITE_METHOD = local
UNITV2SUPPORT_DEPENDENCIES = host-mtd

define UNITV2SUPPORT_BUILD_CMDS
	$(HOST_DIR)/sbin/mkfs.ubifs -m 2048 -e 124KiB -c 128 -r $(@D)/src/ $(BINARIES_DIR)/settings.ubifs
	$(HOST_DIR)/sbin/mkfs.ubifs -m 2048 -e 124KiB -c 2048 $(BINARIES_DIR)/data.ubifs
endef

define UNITV2SUPPORT_MOUNTPOINTS
	mkdir -p $(TARGET_DIR)/settings
	mkdir -p $(TARGET_DIR)/data
endef

UNITV2SUPPORT_TARGET_FINALIZE_HOOKS += UNITV2SUPPORT_MOUNTPOINTS

$(eval $(generic-package))
