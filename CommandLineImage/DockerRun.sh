#!/bin/bash
docker run -t -i -m 1g  -v  /Docker:/DockerIn -v /Docker:/DockerOut -v /Docker:/DockerTodo rsat_debian:4.1.0 /DockerTodo/DockerTodo.sh> /Docker/output.txt
