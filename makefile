MAKEFILE=makefile
DOCKER_IN=~/rsat_docker_files/In
DOCKER_OUT=~/rsat_docker_files/Out
DOCKER_TODO=~/rsat_docker_files/ToDo
ARCHIVE_VERSION=5_1_0
IMAGE_FILE=Images/rsat_debian-${ARCHIVE_VERSION}.tar
IMAGE_VERSION=5.1.0
SERVER_URL=http://192.168.99.100:32801/rsat/

################################################################
## List of targets
usage:
	@echo "usage: make [-OPT='options'] target"
	@echo "implemented targets"
	@perl -ne 'if (/^([a-z]\S+):/){ print "\t$$1\n";  }' ${MAKEFILE}


################################################################
## Download the mots recent RSAT docker image

################################################################
## Load RSAT docker image
##
## This should be done only once after downloading the RSAT docker
## image.
load_image:
	@echo "Loading RSAT docker image ${IMAGE_FILE}"
	docker load -i ${IMAGE_FILE}
	@echo "Image loaded"

check_images:
	docker images


test_retrieve_seq:
	@echo "Running docker"
	@echo "	DOCKER_DIR	${DOCKER_DIR}"
	mkdir -p ${DOCKER_IN} ${DOCKER_OUT} ${DOCKER_TODO}
	rsync -ruptvl CommandLineImage/DockerTodo.sh ${DOCKER_TODO}
	rsync -ruptvl CommandLineImage/list.genes ${DOCKER_IN}
	docker run -t -i -m 1g  \
		-v  ${DOCKER_IN}:/DockerIn \
		-v ${DOCKER_OUT}:/DockerOut \
		-v ${DOCKER_TODO}:/DockerTodo rsat_debian:5.1.0 \
		 /DockerTodo/DockerTodo.sh > ${DOCKER_OUT}/output.txt

################################################################
## Start a container that will run as RSAT server
start_server:
	docker run -t -i -m 1g  -v /rsat_data:/rsat_data -p 32801:80 rsat_debian:${IMAGE_VERSION}


web:
	@echo "Web server is available at ${SERVER_URL}"
	open ${SERVER_URL}
