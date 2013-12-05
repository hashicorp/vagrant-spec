require "rspec"

require "vagrant-spec"

module Vagrant
  module Spec
    class Components
      # Returns the defined components that are runnable.
      #
      # @return [Array<String>]
      def self.components
        [].tap do |result|
          RSpec.world.example_groups.each do |group|
            next if !group.metadata.has_key?(:component)
            result << group.metadata[:component]
          end
        end
      end

      # This loads the default components that are packaged with
      # the vagrant-spec gem.
      def self.load_default!
        load_from!(Vagrant::Spec.source_root.join("acceptance"))
      end

      # This loads the components from the given path. This will
      # recursively load all the Ruby files within this directory
      # that end with "_spec.rb"
      def self.load_from!(path)
        Dir.glob(path.join("**/*_spec.rb")).each do |single|
          load single
        end
      end
    end
  end
end
