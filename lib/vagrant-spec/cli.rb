require "thor"

require "vagrant-spec/components"

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
    end
  end
end
