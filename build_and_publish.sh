#!/bin/bash

# Internal script to build and publish the non-cached version of this buildpack
#  to cloud foundry instance
# It is assumed CF CLI is already avalilable, pointed at correct API and that
#  the user logged in has appropriate permissions

set -eou pipefail

TARGET_BUILDPACK_NAME=python-apt-buildpack-noncached
BUILDPACK_FILE=python_buildpack-*v*.zip

echo "Building..."
rm -f ${BUILDPACK_FILE} || true
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager uncached

echo "Publishing..."
BUILDPACK_LIST=$(cf buildpacks | grep ${TARGET_BUILDPACK_NAME} || true)

if [[ "$BUILDPACK_LIST" == "" ]]; then
	cf create-buildpack ${TARGET_BUILDPACK_NAME} ${BUILDPACK_FILE} 8
else
	cf update-buildpack ${TARGET_BUILDPACK_NAME} -p ${BUILDPACK_FILE}
fi
