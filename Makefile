docker: Dockerfile
	sudo docker build . -t quay.io/quamotion/android-x86-kernel:gvt-stable-4.17
	sudo docker image ls --format "{{.ID}}" quay.io/quamotion/android-x86-kernel:gvt-stable-4.17 > docker

run: docker
	sudo docker run --rm -it $$(cat docker) /bin/bash
