PREFIX = unitv2
DEFCONFIG = ../br2unitv2/configs/unitv2_defconfig
DEFCONFIG_RESCUE = ../br2unitv2/configs/unitv2_rescue_defconfig
EXTERNALS +=../br2autosshkey ../br2unitv2
TOOLCHAIN = arm-buildroot-linux-gnueabihf_sdk-buildroot.tar.gz

all: buildroot buildroot-rescue copy_outputs

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
	cp buildroot/output/images/ipl $(OUTPUTS)/unitv2-ipl
	cp buildroot/output/images/u-boot.img $(OUTPUTS)/unitv2-u-boot.img
	cp buildroot/output/images/kernel.fit $(OUTPUTS)/unitv2-kernel.fit
	cp buildroot/output/images/rootfs.squashfs $(OUTPUTS)/unitv2-rootfs.squashfs
	cp buildroot_rescue/output/images/kernel-rescue.fit $(OUTPUTS)/unitv2-kernel-rescue.fit
