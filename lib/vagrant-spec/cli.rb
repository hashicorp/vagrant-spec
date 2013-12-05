require "thor"

require "vagrant-spec/components"
require "vagrant-spec/acceptance/runner"

module Vagrant
  module Spec
    # This is the CLI that implements the "vagrant-spec" command.
    class CLI < Thor
      option :include, type: :array, desc: "additional include paths for specs"
      desc "components", "output the components that can be tested"
      def components
        Components.load_default!
        if options[:include]
          options[:include].each { |p| Components.load_from!(p) }
        end

        Components.components.sort.each do |c|
          puts c
        end
      end

      option :components, type: :array, desc: "components to test. defaults to all"
      option :config, type: :string, desc: "path to config file to load"
      option :include, type: :array, desc: "additional include paths for specs"
      desc "test", "runs the specs"
      def test
        require "vagrant-spec/acceptance"

        if options[:config]
          load options[:config]
        end

        Acceptance::Runner.new(paths: options[:include]).
          run(options[:components])
      end
    end
  end
end
