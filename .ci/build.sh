#!/usr/bin/env bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


csource="${BASH_SOURCE[0]}"
while [ -h "$csource" ] ; do csource="$(readlink "$csource")"; done
root="$( cd -P "$( dirname "$csource" )/../" && pwd )"

. "${root}/.ci/common.sh"

pushd "${root}" > "${output}"

# Build our gem
wrap gem build *.gemspec \
     "Failed to build Vagrant RubyGem"

# Get the path of our new gem
g=(vagrant*.gem)
gem=$(printf "%s" "${g}")

wrap aws s3 cp "${gem}" "${ASSETS_PRIVATE_BUCKET}/${repository}/vagrant-spec.gem" \
     "Failed to store Vagrant-Spec RubyGem build"
