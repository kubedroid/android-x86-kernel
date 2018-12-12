docker: Dockerfile
	sudo docker build . -t quay.io/quamotion/android-x86-kernel:base
	sudo docker image ls --format "{{.ID}}" quay.io/quamotion/android-x86-kernel:base > docker

run: docker
	sudo docker run --rm -it $$(cat docker) /bin/bash
