# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

require "vagrant"

module VagrantPlugins
  module VagrantSpec
    class Plugin < Vagrant.plugin(2)
      name "vagrant-spec"
      description <<-DESC
      Run vagrant-spec on installed version of Vagrant
      DESC

      command("vagrant-spec") do
        require_relative "command"
        Command
      end
    end
  end
end
