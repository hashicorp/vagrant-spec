# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

require "vagrant-spec/acceptance/output"

module Vagrant
  module Spec
    # Tests the Vagrant version output
    OutputTester[:version] = lambda do |text|
      text =~ /^Vagrant (\d+\.\d+\.\d+(\.[a-z0-9]+)?).*$/
    end
  end
end
