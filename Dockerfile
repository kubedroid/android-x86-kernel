
FROM quay.io/quamotion/android-x86-kernel:base AS build

ENV KERNEL_VERSION=android-x86/kernel-4.18

RUN cd linux \
&& git fetch android-x86 \
&& git checkout $KERNEL_VERSION

RUN cd linux \
# See https://github.com/maurossi/linux/blob/kernel-4.20rc6/drivers/net/wireless/broadcom/wl/build.mk
&& export BROADCOM_DIR=drivers/net/wireless/broadcom/wl \
&& wget https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz \
&& tar zxf hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz -C $BROADCOM_DIR --overwrite -m \
&& rm -rf hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz \
&& mv $BROADCOM_DIR/lib $BROADCOM_DIR/lib64 \
&& patch -p1 -d $BROADCOM_DIR -i wl.patch \
&& patch -p1 -d $BROADCOM_DIR -i linux-recent.patch \
&& patch -p1 -d $BROADCOM_DIR -i linux-48.patch \
&& patch -p1 -d $BROADCOM_DIR -i linux-411.patch \
&& patch -p1 -d $BROADCOM_DIR -i linux-412.patch \
&& patch -p1 -d $BROADCOM_DIR -i linux-415.patch

RUN export install=/android/kernel/ \
&& mkdir -p $install \
&& export gcc=$(pwd)/x86_64-linux-glibc2.11-4.6/bin/x86_64-linux- \
&& export ARCH=x86_64 \
&& export CROSS_COMPILE=$gcc \
&& export INSTALL_MOD_PATH=$install \
&& export INSTALL_PATH=$install \
&& export LOCALVERSION="-kubedroid-guest" \
&& cd linux \
&& cp arch/x86/configs/android-x86_64_defconfig .config \
&& echo "" | make olddefconfig \
#
# SELinux
# See https://osdn.net/projects/android-x86/scm/git/device-generic-common/commits/9c64ea75860c945f9432eac9e013f0c291d9d4f6
#
&& scripts/config --enable CONFIG_SECURITY_PATH \
&& scripts/config --enable CONFIG_SECURITY_SELINUX_BOOTPARAM \
&& scripts/config --set-val CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE 1 \
&& scripts/config --set-val CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE 1 \
&& scripts/config --enable CONFIG_DEFAULT_SECURITY_SELINUX \
&& scripts/config --set-str CONFIG_DEFAULT_SECURITY "selinux" \
&& scripts/config --disable CONFIG_DEFAULT_SECURITY_DAC \
#
# Trim down kernel
#
&& scripts/config --disable DEBUG_INFO \
&& scripts/config --disable CONFIG_BT \
&& scripts/config --disable CONFIG_DRM_RADEON \
&& scripts/config --disable CONFIG_DRM_AMDGPU \
&& scripts/config --disable CONFIG_DRM_NOUVEAU \
&& scripts/config --disable CONFIG_DRM_GMA500 \
&& scripts/config --disable CONFIG_DRM_GMA600 \
&& scripts/config --disable CONFIG_DRM_GMA3600 \
&& scripts/config --disable CONFIG_DRM_UDL \
&& scripts/config --disable CONFIG_DRM_AST \
&& scripts/config --disable CONFIG_DRM_MGAG200 \
&& scripts/config --disable CONFIG_DRM_BOCHS \
&& scripts/config --disable CONFIG_DRM_VMWGFX \
&& scripts/config --disable CONFIG_EXTCON \
&& scripts/config --disable CONFIG_I2C \
&& scripts/config --disable CONFIG_HWMON \
&& scripts/config --disable CONFIG_REISERFS_FS \
&& scripts/config --disable CONFIG_JFS_FS \
&& scripts/config --disable CONFIG_XFS_FS \
&& scripts/config --disable CONFIG_OCFS2_FS \
&& scripts/config --disable CONFIG_BTRFS_FS \
&& scripts/config --disable CONFIG_F2FS_FS \
&& scripts/config --disable CONFIG_UDF_FS \
&& scripts/config --disable CONFIG_9P_FS \
&& scripts/config --disable CONFIG_CIFS \
&& scripts/config --disable CONFIG_FUSE_FS \
&& scripts/config --disable CONFIG_IIO \
&& scripts/config --disable CONFIG_INPUT_LEDS \
&& scripts/config --disable CONFIG_INPUT_JOYDEV \
&& scripts/config --disable CONFIG_INPUT_TOUCHSCREEN \
&& scripts/config --disable CONFIG_INPUT_MISC \
# && scripts/config --disable CONFIG_MEDIA_SUPPORT \
&& scripts/config --disable CONFIG_NET_VENDOR_3COM \
&& scripts/config --disable CONFIG_NET_VENDOR_ADAPTEC \
&& scripts/config --disable CONFIG_NET_VENDOR_AGERE \
&& scripts/config --disable CONFIG_NET_VENDOR_ALTEON \
&& scripts/config --disable CONFIG_NET_VENDOR_AMAZON \
&& scripts/config --disable CONFIG_NET_VENDOR_AMD \
&& scripts/config --disable CONFIG_NET_VENDOR_ARC \
&& scripts/config --disable CONFIG_NET_VENDOR_ATHEROS \
&& scripts/config --disable CONFIG_NET_VENDOR_AURORA \
&& scripts/config --disable CONFIG_NET_VENDOR_BROADCOM \
&& scripts/config --disable CONFIG_NET_VENDOR_BROCADE \
&& scripts/config --disable CONFIG_NET_VENDOR_CAVIUM \
&& scripts/config --disable CONFIG_NET_VENDOR_CHELSIO \
&& scripts/config --disable CONFIG_NET_VENDOR_CISCO \
&& scripts/config --disable CONFIG_NET_VENDOR_DEC \
&& scripts/config --disable CONFIG_NET_VENDOR_DLINK \
&& scripts/config --disable CONFIG_NET_VENDOR_EMULEX \
&& scripts/config --disable CONFIG_NET_VENDOR_EZCHIP \
&& scripts/config --disable CONFIG_NET_VENDOR_EXAR \
&& scripts/config --disable CONFIG_NET_VENDOR_FUJITSU \
&& scripts/config --disable CONFIG_NET_VENDOR_HP \
# keep intel
&& scripts/config --disable CONFIG_NET_VENDOR_I825XX \
&& scripts/config --disable CONFIG_NET_VENDOR_MARVELL \
&& scripts/config --disable CONFIG_NET_VENDOR_MELLANOX \
&& scripts/config --disable CONFIG_NET_VENDOR_MICREL \
&& scripts/config --disable CONFIG_NET_VENDOR_MICROCHIP \
&& scripts/config --disable CONFIG_NET_VENDOR_MYRI \
&& scripts/config --disable CONFIG_NET_VENDOR_NATSEMI \
&& scripts/config --disable CONFIG_NET_VENDOR_NETRONOME \
&& scripts/config --disable CONFIG_NET_VENDOR_8390 \
&& scripts/config --disable CONFIG_NET_VENDOR_NVIDIA \
&& scripts/config --disable CONFIG_NET_VENDOR_OKI \
&& scripts/config --disable CONFIG_NET_VENDOR_QLOGIC \
&& scripts/config --disable CONFIG_NET_VENDOR_QUALCOMM \
&& scripts/config --disable CONFIG_NET_VENDOR_REALTEK \
&& scripts/config --disable CONFIG_NET_VENDOR_RENESAS \
&& scripts/config --disable CONFIG_NET_VENDOR_RDC \
&& scripts/config --disable CONFIG_NET_VENDOR_ROCKER \
&& scripts/config --disable CONFIG_NET_VENDOR_SAMSUNG \
&& scripts/config --disable CONFIG_NET_VENDOR_SEEQ \
&& scripts/config --disable CONFIG_NET_VENDOR_SILAN \
&& scripts/config --disable CONFIG_NET_VENDOR_SIS \
&& scripts/config --disable CONFIG_NET_VENDOR_SMSC \
&& scripts/config --disable CONFIG_NET_VENDOR_STMICRO \
&& scripts/config --disable CONFIG_NET_VENDOR_SUN \
&& scripts/config --disable CONFIG_NET_VENDOR_SYNOPSYS \
&& scripts/config --disable CONFIG_NET_VENDOR_TEHUTI \
&& scripts/config --disable CONFIG_NET_VENDOR_TI \
&& scripts/config --disable CONFIG_NET_VENDOR_VIA \
&& scripts/config --disable CONFIG_NET_VENDOR_WIZNET \
&& scripts/config --disable CONFIG_NET_VENDOR_XIRCOM \
&& scripts/config --disable CONFIG_MEDIA_TUNER \
&& scripts/config --disable CONFIG_SCSI \
&& scripts/config --disable CONFIG_SND \
&& scripts/config --disable CONFIG_SOC_CAMERA \
&& scripts/config --disable CONFIG_VIDEO_DEV \
&& scripts/config --disable CONFIG_WIRELESS \
&& scripts/config --disable CONFIG_MAC80211 \
#
# Build
#
&& touch .scmversion \
&& make -j$(nproc) \
&& make modules_install \
&& make install

RUN export gcc=$(pwd)/x86_64-linux-glibc2.11-4.6/bin/x86_64-linux- \
&& export ARCH=x86_64 \
&& export CROSS_COMPILE=$gcc \
&& cd linux \
&& make modules M=../virtual_touchscreen/ \
&& cp ../virtual_touchscreen/*.ko /android/kernel/

RUN cd linux \
&& cp .config /android/kernel/

FROM ubuntu:bionic

COPY --from=build /android/kernel/ /android/kernel/
