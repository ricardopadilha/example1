#!/bin/sh

# Do whatever needs to be done to build the app here.
# Keep in mind that the environment is already set to:
# GOARCH=arm
# GOARM=7
# GOPATH=/mnt/DroboFS/Shares/DroboApps/example1

set -o errexit
set -o nounset
set -o xtrace

pushd src

go build -o drive drive.go

# copy result out of docker
cp drive ~/dist/

popd
