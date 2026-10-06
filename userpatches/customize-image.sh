#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4

Main() {
	export DEBIAN_FRONTEND=noninteractive

	echo "Running custom image configuration for DG3399..."

	# Ensure network and basic diagnostic utilities
	apt-get update || true
	apt-get install -y --no-install-recommends \
		alsa-utils \
		bash-completion \
		curl \
		htop \
		i2c-tools \
		net-tools \
		pciutils \
		usbutils \
		vim \
		wget || true

	apt-get clean || true
}

Main "$@"
