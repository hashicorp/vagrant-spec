require "thor"

require "vagrant-spec/acceptance"
require "vagrant-spec/acceptance/runner"
require "vagrant-spec/components"

module Vagrant
  module Spec
    # This is the CLI that implements the "vagrant-spec" command.
    class CLI < Thor
      option :config, type: :string, desc: "path to config file to load"
      option :include, type: :array, desc: "additional include paths for specs"
      desc "components", "output the components that can be tested"
      def components
        if options[:config]
          load options[:config]
        end

        runner = Acceptance::Runner.new(paths: options[:include])
        runner.components.sort.each do |c|
          puts c
        end
      end

      option :components, type: :array, desc: "components to test. defaults to all"
      option :config, type: :string, desc: "path to config file to load"
      option :include, type: :array, desc: "additional include paths for specs"
      desc "test", "runs the specs"
      def test
        if options[:config]
          load options[:config]
        end

        Acceptance::Runner.new(paths: options[:include]).
          run(options[:components])
      end
    end
  end
end
