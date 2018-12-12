docker: Dockerfile
	sudo docker build . -t quay.io/quamotion/android-x86-kernel:8.1-rc2
	sudo docker image ls --format "{{.ID}}" quay.io/quamotion/android-x86-kernel:8.1-rc2 > docker

run: docker
	sudo docker run --rm -it $$(cat docker) /bin/bash
