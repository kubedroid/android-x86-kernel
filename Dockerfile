FROM quay.io/quamotion/android-x86-kernel:base AS build

ENV KERNEL_VERSION=android-x86-7.1-r2

RUN git clone https://github.com/kubedroid/virtual_touchscreen \
&& cd linux \
&& git remote add android-x86 https://scm.osdn.net/gitroot/android-x86/kernel.git \
&& git fetch android-x86 \
&& git checkout $KERNEL_VERSION

RUN cd linux \
&& cp arch/x86/configs/android-x86_64_defconfig .config \
&& echo "" | make oldconfig

RUN apt-get update \
&& apt-get install -y kmod

RUN cd linux \
&& export BROADCOM_DIR=drivers/net/wireless/broadcom/wl \
&& wget https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz \
&& tar zxf hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz -C $BROADCOM_DIR --overwrite -m \
&& rm -rf hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz \
&& mv $BROADCOM_DIR/lib $BROADCOM_DIR/lib64 \
&& patch -p1 -d $BROADCOM_DIR -i wl.patch \
&& patch -p1 -d $BROADCOM_DIR -i linux-recent.patch \
&& patch -p1 -d $BROADCOM_DIR -i linux-48.patch \
&& if [ -f linux-411.patch ]; then patch -p1 -d $BROADCOM_DIR -i linux-411.patch; fi \
&& if [ -f linux-412.patch ]; then patch -p1 -d $BROADCOM_DIR -i linux-412.patch; fi \
&& if [ -f linux-415.patch ]; then patch -p1 -d $BROADCOM_DIR -i linux-415.patch; fi

RUN export install=/android/kernel/$KERNEL_VERSION \
&& mkdir -p $install \
&& export gcc=$(pwd)/x86_64-linux-glibc2.11-4.6/bin/x86_64-linux- \
&& export ARCH=x86_64 \
&& export CROSS_COMPILE=$gcc \
&& export INSTALL_MOD_PATH=$install \
&& export INSTALL_PATH=$install \
&& LOCALVERSION="-kubedroid-guest" \
&& cd linux \
&& make -j$(nproc) \
&& make modules_install \
&& make install

RUN export gcc=$(pwd)/x86_64-linux-glibc2.11-4.6/bin/x86_64-linux- \
&& export ARCH=x86_64 \
&& export CROSS_COMPILE=$gcc \
&& cd kernel \
&& make modules M=../virtual_touchscreen/ \
&& cp ../virtual_touchscreen/*.ko /android/kernel/

FROM ubuntu:bionic

COPY --from=build /android/kernel/ /android/kernel/
