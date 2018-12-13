docker: Dockerfile
	sudo docker build . -t quay.io/quamotion/android-x86-kernel:kernel-4.16
	sudo docker image ls --format "{{.ID}}" quay.io/quamotion/android-x86-kernel:kernel-4.16 > docker

run: docker
	sudo docker run --rm -it $$(cat docker) /bin/bash
