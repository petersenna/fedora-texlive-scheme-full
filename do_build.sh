#!/bin/bash

# Uncomment these lines to make it work inside Fedora' toolbox
#shopt -s expand_aliases
#alias docker="flatpak-spawn --host podman"

DOCKERFILE="Dockerfile"
if [ ! -f $DOCKERFILE ] ; then
	echo "$DOCKERFILE not found"
	exit 1
fi

# Build only if needed. Saves 10+ seconds on Windows...
IMAGENAME=fedora-texlive-scheme-full
docker image ls |grep $IMAGENAME &> /dev/null
if test $? -ne "0"; then
  docker build -t fedora-texlive-scheme-full . -f Dockerfile
fi

AB=$(realpath $(pwd))
docker run --rm=true -i \
  -v ${AB}:${HOME} \
  -w ${HOME} -it  mcec-cv $@
