#!/bin/bash
BUILD_DEPENDENCIES="git nano cmake ninja-build devscripts build-essential lintian python3 python3-dev python3-pip python3-jsonschema  python3-jinja2 qt6-base-dev qt6-serialport-dev qt6-websockets-dev libudev-dev libxkbcommon-dev libvulkan-dev libgl1-mesa-dev libusb-1.0-0-dev libasound2-dev libturbojpeg0-dev libjpeg-dev libssl-dev pkg-config libftdi1-dev libcec-dev libp8-platform-dev libudev-dev libdrm-dev libxcb-randr0-dev libxcb-shm0-dev libxcb-image0-dev libx11-dev libxrandr-dev libxrender-dev libxcb-util0-dev libxcb-render0-dev"
HYPERION_RELEASE_TAG="2.1.1"
HYPERION_GIT_REPO_URL="https://github.com/hyperion-project/hyperion.ng.git"
BUILD_TYPE="Release"
ARCHITECTURE="amd64"
BUILD_PLATFORM=""
CODE_DIR="/source"
BUILD_DIR="/build"
BIN_DIR="/usr/bin/hyperiond"
BUILD_ARGS=""

# determine platform cmake parameter
if [[ ! -z "$BUILD_PLATFORM" ]]; then
	PLATFORM="-DPLATFORM=${BUILD_PLATFORM}"
fi

echo "Installing build dependencies"
apt-get install -y -q $BUILD_DEPENDENCIES
pip install jsonschema

echo "Cloning source code from Hyperion repository with ${HYPERION_RELEASE_TAG} tag"
git clone --depth 1 --recurse-submodules -q --branch ${HYPERION_RELEASE_TAG} ${HYPERION_GIT_REPO_URL} ${CODE_DIR}

mkdir -p ${BUILD_DIR}
echo "Compiling application"
cmake -S ${CODE_DIR} -B ${BUILD_DIR} -G Ninja -DCMAKE_INSTALL_PREFIX=${BIN_DIR} -DENABLE_QT=OFF -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ${PLATFORM} ${BUILD_ARGS}
cd ${BUILD_DIR}
cmake --build .
cmake --build . --target install/strip
#remove desktop components
rm -rf /usr/bin/hyperiond/share/hyperion/desktop