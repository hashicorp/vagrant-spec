# Copyright IBM Corp. 2013, 2023
# SPDX-License-Identifier: MPL-2.0

module VSHB
  class Command < Vagrant.plugin("2", "command")
    def execute
      puts "I HAVE BEEN EXECUTED"
    end
  end
end
