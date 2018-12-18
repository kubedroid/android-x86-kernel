# android-x86-kernel

[![Docker Repository on Quay](https://quay.io/repository/kubedroid/android-x86-kernel/status "Docker Repository on Quay")](https://quay.io/repository/kubedroid/android-x86-kernel)

This repository contains the scripts which generate Docker images which contain a copy of the Linux kernel
which has been prepared to be used with an Android-x86 VM running inside a Kubernetes cluster.

The kernel contained in these images is based off the Android-x86 kernels published at
[https://github.com/maurossi/linux](https://github.com/maurossi/linux).

The build process:
- Tries to mimic the upstream android-x86 build process. For example:
  * SELinux is enabled
  * The Broadcom WLAN drivers are added to the kernel tree
  * The Android variant of GCC is used to compile the kernel
- Disables some drivers (such as most network drivers) to reduce the size of the kernel image and to
  limit the time required to compile the kernel
- Builds a `virtual_touchscreen` module which can be used to inject a virtual touchscreen in the kernel
  image.

This container image is intended to be used by the KubeDroid build process.

## About

This repository is part of [KubeDroid](https://github.com/kubedroid). You can use KubeDroid to run Android-x86
emulators inside Kubernetes clusters, using [KubeVirt](https://kubevirt.io)

KubeDroid is sponsored by [Quamotion](http://quamotion.mobi). Quamotion provides test automation software for
mobile devices.

