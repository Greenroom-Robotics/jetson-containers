#!/usr/bin/env bash

set -e
source scripts/docker_base.sh

cp /etc/apt/trusted.gpg.d/jetson-ota-public.asc .
	
sh ./scripts/docker_build.sh greenroom/greenvision:l4t-r$L4T_VERSION-py3.8 Dockerfile.greenvision \
		--build-arg BASE_IMAGE=$BASE_IMAGE \
		--build-arg L4T_APT_SOURCE="deb https://repo.download.nvidia.com/jetson/common r32.4 main"


