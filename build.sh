#!/bin/bash

# Set env vars for building
export GOPATH=$PWD
export GOBIN=$PWD/bin
export GOFLAGS="-s -w"

# Do we even have go installed?
command -v go >/dev/null 2>&1 || { echo >&2 "I require go but it's not installed.  Aborting."; exit 1; }

# Are we building or cleaning house?
if [[ "$1" == "clean" ]]; then
  rm $PWD/bin/* 2>/dev/null
  rm -r $PWD/pkg 2>/dev/null
  rm -fr $PWD/src/github.com 2>/dev/null
  rm -r $PWD/releases 2>/dev/null
else
  # Download dependencies
  if [ ! -d "$GOPATH/src/github.com/tarm/serial" ]; then
    git clone https://github.com/tarm/serial.git $GOPATH/src/github.com/tarm/serial
  fi

  # Make required dir if needed
  if [ ! -d "$GOBIN" ]; then
    mkdir $GOBIN
  fi

  # build the things!
  echo "Building amd64..."
  env GOOS=linux GOARCH=amd64 go build -ldflags="$GOFLAGS" -o $GOBIN/rfled-server-amd64 $PWD/src/rfled-server.go
  echo "Building armv6..."
  env GOOS=linux GOARCH=arm GOARM=6 go build -ldflags="$GOFLAGS" -o $GOBIN/rfled-server-armv6 $PWD/src/rfled-server.go
  echo "Building armv7..."
  env GOOS=linux GOARCH=arm GOARM=7 go build -ldflags="$GOFLAGS" -o $GOBIN/rfled-server-armv7 $PWD/src/rfled-server.go

  # We finished!
  if [ $? -eq 0 ]; then
    echo "Build Complete! Binary is in $GOBIN"
  fi

  # Are we building shippable releases?
  if [[ "$1" == "package" ]]; then
    if [[ $EUID -ne 0 ]]; then
      echo "Error, package mode must be ran as root" 1>&2
      exit 1
    fi
    echo "Building Releases..."
    for arch in amd64 armv6 armv7;
    do
      echo "Packaging $arch"
      if [ ! -d "$GOPATH/releases/tmp/$arch/rfled-server/usr/sbin" ]; then
          mkdir -p $GOPATH/releases/tmp/$arch/rfled-server/usr/sbin
      fi
      cp $GOBIN/rfled-server-$arch $GOPATH/releases/tmp/$arch/rfled-server/usr/sbin/rfled-server
      chmod +x $GOPATH/releases/tmp/$arch/rfled-server/usr/sbin/rfled-server
      cp -r $GOPATH/src/etc $GOPATH/releases/tmp/$arch/rfled-server/
      chmod +x $GOPATH/releases/tmp/$arch/rfled-server/etc/init.d/rfled-server
      chown -R root:root $GOPATH/releases/tmp/$arch/rfled-server
      tar -pczf $GOPATH/releases/rfled-server-$arch-$(date +"%F-%H%M%S").tar.gz -C $GOPATH/releases/tmp/$arch ./rfled-server
    done
    rm -rf $GOPATH/releases/tmp/
    echo "Done! :)"
  fi
fi
