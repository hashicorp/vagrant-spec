# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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
          o.banner = "Usage: vagrant vagrant-spec [options] <config file path>"
          o.separator ""
          o.separator "Options:"
          o.separator ""

          o.on("-b", "--[no-]builtin", "Use builtin test paths") do |b|
            options[:builtin] = b
          end

          o.on("-c", "--component COMPONENT", "Specific component to test") do |c|
            options[:components] ||= []
            options[:components] << c
          end

          o.on("-w", "--without-component COMPONENT", "Specific component to not test") do |c|
            options[:without_components] ||= []
            options[:without_components] << c
          end

          o.on("-e", "--example EXAMPLE", "Specific example to test") do |e|
            options[:example] = e
          end
        end

        argv = parse_options(opts)
        return if !argv
        config_path = argv.first
        if argv.empty? || argv.length > 1 || !File.file?(config_path)
          raise Vagrant::Errors::CLIInvalidUsage,
            help: opts.help.chomp
        end

        # Load the Vagrant Spec CLI to start configuration
        require "vagrant-spec/cli"

        use_builtin = options.key?(:builtin) ? options.delete(:builtin) : true

        if use_builtin
          require Vagrant.source_root.join("test/acceptance/base").to_s
        end

        Vagrant::Spec::Acceptance.configure do |c|
          c.run_mode = "plugin"
          if use_builtin
            c.component_paths << Vagrant.source_root.join("test/acceptance").to_s
            c.skeleton_paths << Vagrant.source_root.join("test/acceptance/skeletons").to_s
          end
        end

        cli = Vagrant::Spec::CLI.new([], options.merge(config: config_path))
        cli.test
      end
    end
  end
end
