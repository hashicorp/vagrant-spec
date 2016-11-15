require "optparse"

module VagrantPlugins
  module VagrantSpec
    class Command < Vagrant.plugin(2, :command)
      def self.synopsis
        "run vagrant-spec on installed version of Vagrant"
      end

      def execute
        options = {}
        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant vagrant-spec <config file path>"
        end

        argv = parse_options(opts)
        return if !argv
        if argv.empty? || argv.length > 1
          raise Vagrant::Errors::CLIInvalidUsage,
            help: opts.help.chomp
        end

        require "vagrant-spec/cli"
        require Vagrant.source_root.join("test/acceptance/base").to_s

        Vagrant::Spec::Acceptance.configure do |c|
          c.component_paths << Vagrant.source_root.join("test/acceptance").to_s
          c.skeleton_paths << Vagrant.source_root.join("test/acceptance/skeletons").to_s
        end

        config_path = argv.first
        if !File.file?(config_path)
          raise ArgumentError.new "Invalid configuration file path provided"
        end

        cli = Vagrant::Spec::CLI.new([], config: config_path)
        cli.test
      end
    end
  end
end
