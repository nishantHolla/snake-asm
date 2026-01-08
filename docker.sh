#!/bin/bash

if [[ "$1" == "build" ]]; then
  docker build -t snake-asm .
elif [[ "$1" == "run" ]]; then
  docker run --rm -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$PWD:/workspace" \
  snake-asm bash ./run.sh
else
  echo "usage: ./docker.sh [run|build]"
fi
