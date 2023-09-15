# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module Vagrant
  module Spec
    VERSION = '0.0.1.' + `git log --pretty=format:'%at.%h' -n 1` + '.git'
  end
end
