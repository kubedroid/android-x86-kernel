FROM ubuntu:bionic

RUN apt-get update \
&& apt-get install -y build-essential git bison flex libssl-dev libelf-dev bc python wget kmod \
&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/torvalds/linux \
&& git -C linux remote add android-x86 https://scm.osdn.net/gitroot/android-x86/kernel.git \
&& git -C linux fetch android-x86 \
&& git -C linux remote add maurossi https://github.com/maurossi/linux \
&& git -C linux fetch maurossi \
&& git -C linux remote add gvt-linux https://github.com/intel/gvt-linux \
&& git -C linux fetch gvt-linux \
&& git -C linux remote add chromium https://chromium.googlesource.com/chromiumos/third_party/kernel \
&& git -C linux fetch chromium \
&& git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6 \
&& git clone https://github.com/kubedroid/virtual_touchscreen \
&& git config --global user.email "build@kubedroid.io" \
&& git config --global user.name "Kubedroid build"
