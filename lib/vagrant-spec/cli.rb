require "thor"

require "vagrant-spec/components"
require "vagrant-spec/runner"

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
      option :include, type: :array, desc: "additional include paths for specs"
      desc "test", "runs the specs"
      def test
        Components.load_default!
        if options[:include]
          options[:include].each { |p| Components.load_from!(p) }
        end

        components = options[:components] || Components.components
        Runner.run(components)
      end
    end
  end
end
