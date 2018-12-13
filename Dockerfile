
FROM quay.io/quamotion/android-x86-kernel:base AS build

ENV KERNEL_VERSION=gvt-linux/gvt-stable-4.17

RUN cd linux \
&& git fetch gvt-linux \
&& git checkout $KERNEL_VERSION \
&& git config --global user.email "build@kubedroid.io" \
&& git config --global user.email "KubeDroid Build Agent" \
# && git cherry-pick e9ef547c41ce071b90c720c24bfc3d3c3a03fbc0 \
&& git cherry-pick 18e4b0491577b6e13a47a52148482f2af1902d0b \
&& git cherry-pick b858129dab5b207da8f1198a4d01d104c6ddcabb \
&& git cherry-pick ee4473e49459cd2c042a091d23ea806bc9e9490e \
&& git cherry-pick 6f5f96fd2df85771674adcf997058a6146971c28 \
&& git cherry-pick 229d587317c4dba4be21402d33275205d260b11b \
&& git cherry-pick 4acebc187f0aa3cbbf8187daa8d5634809602395 \
# && git cherry-pick 3453a5a5074b05b518ea627a9e2ccfec8bea33c9 \
&& git cherry-pick cb5f617fb25afe4b81cc6c5905443758e187a315 \
&& git cherry-pick 059b3e490d3a5e1a301b957f4535c61d3525d16a

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
# https://github.com/NixOS/nixpkgs/issues/34383
#
&& scripts/config --disable CONFIG_RETPOLINE \
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
# && scripts/config --disable DEBUG_INFO \
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
# && scripts/config --disable CONFIG_EXTCON \
# && scripts/config --disable CONFIG_I2C \
# && scripts/config --disable CONFIG_HWMON \
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
# && scripts/config --disable CONFIG_IIO \
# && scripts/config --disable CONFIG_INPUT_LEDS \
# && scripts/config --disable CONFIG_INPUT_JOYDEV \
# && scripts/config --disable CONFIG_INPUT_TOUCHSCREEN \
# && scripts/config --disable CONFIG_INPUT_MISC \
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
# && scripts/config --disable CONFIG_MEDIA_TUNER \
# && scripts/config --disable CONFIG_SCSI \
# && scripts/config --disable CONFIG_SND \
# && scripts/config --disable CONFIG_SOC_CAMERA \
# && scripts/config --disable CONFIG_VIDEO_DEV \
&& scripts/config --disable CONFIG_WIRELESS \
&& scripts/config --disable CONFIG_MAC80211 \
&& scripts/config --disable CONFIG_WLAN \
&& scripts/config --disable CONFIG_CFG80211 \
&& scripts/config --disable WLAN_VENDOR_BROADCOM \
# These drivers have no declared dependencies in 4.13, so
# we need to explicitely exclude them
&& scripts/config --disable CONFIG_RTL8723BU \
&& scripts/config --disable CONFIG_RTL8821AU \
&& scripts/config --disable CONFIG_DVB \
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
