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
