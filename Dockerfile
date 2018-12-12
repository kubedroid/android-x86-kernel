FROM ubuntu:bionic

RUN apt-get update \
&& apt-get install -y build-essential git bison flex libssl-dev libelf-dev bc python wget kmod \
&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/torvalds/linux \
&& git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6
