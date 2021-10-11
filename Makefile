PREFIX = unitv2
DEFCONFIG = ../br2unitv2/configs/unitv2_defconfig
DEFCONFIG_RESCUE = ../br2unitv2/configs/unitv2_rescue_defconfig
EXTERNALS +=../br2autosshkey ../br2unitv2
TOOLCHAIN = arm-buildroot-linux-gnueabihf_sdk-buildroot.tar.gz

all: buildroot buildroot-rescue copy_outputs upload

bootstrap.stamp:
	git submodule init
	git submodule update
	touch bootstrap.stamp

./br2secretsauce/common.mk: bootstrap.stamp
./br2secretsauce/rescue.mk: bootstrap.stamp

bootstrap: bootstrap.stamp

include ./br2secretsauce/common.mk
include ./br2secretsauce/rescue.mk

copy_outputs:
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/ipl)
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/u-boot.img)
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/kernel.fit)
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/rootfs.squashfs)
	$(call copy_to_outputs, $(BUILDROOT_RESCUE_PATH)/output/images/kernel-rescue.fit)

upload:
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/ipl)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/u-boot.img)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/kernel.fit)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/rootfs.squashfs)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_RESCUE_PATH)/output/images/kernel-rescue.fit)
