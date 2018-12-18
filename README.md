# android-x86-kernel

This repository contains the scripts which generate Docker images which contain a copy of the Linux kernel
which has been prepared to be used with an Android-x86 VM running inside a Kubernetes cluster.

The base branch contains the scripts used for a base image, which contains the tools required to compile
the kernel and a copy of the kernel git repository.

This container image is intended to be used by the KubeDroid build process.

## About

This repository is part of [KubeDroid](https://github.com/kubedroid). You can use KubeDroid to run Android-x86
emulators inside Kubernetes clusters, using [KubeVirt](https://kubevirt.io)

KubeDroid is sponsored by [Quamotion](http://quamotion.mobi). Quamotion provides test automation software for
mobile devices.

