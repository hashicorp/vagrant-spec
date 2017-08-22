require "rspec"

require "vagrant-spec"

module Vagrant
  module Spec
    class Components
      def initialize(paths)
        @paths = paths
        reload!
      end

      # Loads the components from the given paths
      def reload!
        # Delete the existing example groups
        RSpec.world.example_groups.clear

        @paths.each do |path|
          Dir.glob(File.join(path, "**/*_{output,spec}.rb")).each do |single|
            load single
          end
        end
      end

      # Returns the defined components that are runnable.
      #
      # @return [Array<String>]
      def components
        [].tap do |result|
          RSpec.world.example_groups.each do |group|
            next if !group.metadata.has_key?(:component)
            result << group.metadata[:component]
          end
        end
      end

      # Returns the defined provider features.
      def provider_features
        [].tap do |result|
          groups = RSpec.world.shared_example_group_registry.send(:shared_example_groups)
          groups[:main].each do |name, _|
            match = /^provider\/(.+?)$/.match(name)
            result << match[1] if match
          end
        end
      end

      protected

      # This loads the default components that are packaged with
      # the vagrant-spec gem.
      def self.load_default!
        load_from!(Vagrant::Spec.source_root.join("acceptance"))
      end
    end
  end
end
