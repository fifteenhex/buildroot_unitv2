################################################################################
#
# RTL8188FU
#
################################################################################

RTL8188FU_VERSION = a0168ba60e7228d579471affc86bb7244b650667
RTL8188FU_SITE = $(call github,fifteenhex,rtl8188fu,$(RTL8188FU_VERSION))
RTL8188FU_LICENSE = GPL-2.0, proprietary (firmware/rtl8188fufw.bin firmware blob)
RTL8188FU_LICENSE_FILES = COPYING
RTL8188FU_MODULE_MAKE_OPTS = CONFIG_RTL8188FU=m

define RTL8188FU_INSTALL_FIRMWARE
	$(INSTALL) -D -m 644 $(@D)/firmware/rtl8188fufw.bin \
		$(TARGET_DIR)/lib/firmware/rtlwifi/rtl8188fufw.bin
endef
RTL8188FU_POST_INSTALL_TARGET_HOOKS += RTL8188FU_INSTALL_FIRMWARE

$(eval $(kernel-module))
$(eval $(generic-package))
