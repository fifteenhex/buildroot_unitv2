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

define ubi-add-vol
	echo "[$2]\n"\
		"\tmode=ubi\n"\
		"\tvol_id=$1\n"\
		"\tvol_name=$2\n"\
		"\tvol_size=$3\n"\
		"\tvol_type=$4\n"\
		"\timage=$5\n"\
		"\tvol_alignment=1\n"\
		>> ubinize.cfg.tmp
endef

.PHONY: ubi.img upload
ubi.img:
	- rm ubinize.cfg.tmp
	dd if=/dev/zero bs=1024 count=256 | tr '\000' '1' > env.img
	$(call ubi-add-vol,0,uboot,1MiB,static,buildroot/output/images/u-boot.img)
	$(call ubi-add-vol,1,env,256KiB,static,env.img)
	$(call ubi-add-vol,2,rescue,16MiB,static,buildroot_rescue/output/images/kernel-rescue.fit)
	$(call ubi-add-vol,3,kernel,16MiB,static,buildroot/output/images/kernel.fit)
	$(call ubi-add-vol,4,rootfs,64MiB,dynamic,buildroot/output/images/rootfs.squashfs)
	/usr/sbin/ubinize -o $@ -p 128KiB -m 2048 -s 2048 ubinize.cfg.tmp

copy_outputs: ubi.img
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/ipl)
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/u-boot.img)
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/kernel.fit)
	$(call copy_to_outputs, $(BUILDROOT_PATH)/output/images/rootfs.squashfs)
	$(call copy_to_outputs, ubi.img)
ifeq ($(BRANCH), master)
	$(call copy_to_outputs, $(BUILDROOT_RESCUE_PATH)/output/images/kernel-rescue.fit)
endif

upload:
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/ipl)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/u-boot.img)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/kernel.fit)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_PATH)/output/images/rootfs.squashfs)
	$(call upload_to_tftp_with_scp, ubi.img)
ifeq ($(BRANCH), master)
	$(call upload_to_tftp_with_scp, $(BUILDROOT_RESCUE_PATH)/output/images/kernel-rescue.fit)
endif
