require "rspec"

require "vagrant-spec"

module Vagrant
  module Spec
    class Components
      def initialize(world, paths)
        @paths = paths
        @world = world
        reload!
      end

      # Loads the components from the given paths
      def reload!
        with_world do
          # Delete the existing example groups
          @world.example_groups.clear

          @paths.each do |path|
            Dir.glob(File.join(path, "**/*.rb")).each do |single|
              load single
            end
          end
        end
      end

      # Returns the defined components that are runnable.
      #
      # @return [Array<String>]
      def components
        [].tap do |result|
          with_world do
            RSpec.world.example_groups.each do |group|
              next if !group.metadata.has_key?(:component)
              result << group.metadata[:component]
            end
          end
        end
      end

      # Returns the defined provider features.
      def provider_features
        [].tap do |result|
          groups = RSpec::Core::SharedExampleGroup.registry.shared_example_groups
          groups["main"].each do |name, _|
            match = /^provider\/(.+?)$/.match(name)
            result << match[1] if match
          end
        end
      end

      protected

      def with_world
        old_world = RSpec.world
        RSpec.world = @world
        yield
      ensure
        RSpec.world = old_world
      end

      # This loads the default components that are packaged with
      # the vagrant-spec gem.
      def self.load_default!
        load_from!(Vagrant::Spec.source_root.join("acceptance"))
      end
    end
  end
end
