#!/bin/bash

# check args
if [ $# -lt 1 ]; then
    echo "Error: Version argument is required."
    echo "Usage: v$0 <version> [platform] (default platform: linux_amd64)"
    exit 1
fi

VERSION=$1
PLATFORM=${2:-linux_amd64}
PACKAGE_NAME=certimate.zip
IMAGE_NAME_VERSIONED=registry.cn-shanghai.aliyuncs.com/maxwen/certimate-docker:${VERSION}
IMAGE_NAME_LATEST=registry.cn-shanghai.aliyuncs.com/maxwen/certimate-docker:latest

DOWNLOAD_URL="https://github.com/usual2970/certimate/releases/download/v${VERSION}/certimate_${VERSION}_${PLATFORM}.zip"

mkdir -p ./package

# download release package
echo "Downloading certimate ${VERSION} for ${PLATFORM}..."
if ! curl -L --fail --progress-bar -o ${PACKAGE_NAME} "${DOWNLOAD_URL}"; then
    echo "Error: Failed to download package. Check version/platform availability."
    exit 1
fi

# unpack
echo "Extracting package..."
unzip -j -o ${PACKAGE_NAME} 'certimate*' -d ./package
chmod +x ./package/certimate

# cleanup
rm -f ${PACKAGE_NAME}

echo "Successfully downloaded and extracted certimate ${VERSION} for ${PLATFORM}"

# build docker image
docker build -t ${IMAGE_NAME_VERSIONED} .
docker push ${IMAGE_NAME_VERSIONED}
docker tag ${IMAGE_NAME_VERSIONED} ${IMAGE_NAME_LATEST}
docker push ${IMAGE_NAME_LATEST}

echo "Successfully built and pushed Docker image: \n ${IMAGE_NAME_VERSIONED}\n ${IMAGE_NAME_LATEST}"