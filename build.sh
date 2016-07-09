#!/bin/bash

# Set env vars for building
export GOPATH=$PWD
export GOBIN=$PWD/bin

# Do we even have go installed?
command -v go >/dev/null 2>&1 || { echo >&2 "I require go but it's not installed.  Aborting."; exit 1; }

# Are we building or cleaning house?
if [[ "$1" == "clean" ]]; then
  rm $PWD/bin/*
  rm -r $PWD/pkg
  rm -fr $PWD/src/github.com

else
  # Download dependencies
  if [ ! -d "$GOPATH/src/github.com/tarm/serial" ]; then
    git clone https://github.com/tarm/serial.git $GOPATH/src/github.com/tarm/serial
  fi

  # Make required dir if needed
  if [ ! -d "$GOPATH/bin" ]; then
    mkdir $GOBIN
  fi

  # build
  go install ./src/rfled-server.go

  # We finished
  if [ $? -eq 0 ]; then
    echo "Build Complete! Binary is in $GOBIN"
  fi
fi
