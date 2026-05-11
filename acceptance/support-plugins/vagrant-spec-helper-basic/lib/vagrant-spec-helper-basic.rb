# Copyright IBM Corp. 2013, 2026
# SPDX-License-Identifier: MPL-2.0

module VSHB
  class Plugin < Vagrant.plugin("2")
    name "vshb"

    command("vshb") do
      require_relative "vshb/command"
      Command
    end
  end
end
