module VSHB
  class Plugin < Vagrant.plugin("2")
    name "vshb"

    command("vshb") do
      require_relative "vshb/command"
      Command
    end
  end
end
