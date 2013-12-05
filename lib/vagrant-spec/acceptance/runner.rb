require "rspec"

module Vagrant
  module Spec
    module Acceptance
      # The runner configures RSpec to run the given components.
      class Runner
        def initialize(paths: nil)
          @paths = paths || []
          @world = RSpec::Core::World.new
        end

        def run(components)
          args = ["--format=d",
                  "--color",]


          with_world do
            # Reset the world so we don't have any components
            @world.example_groups.clear

            # Load the components
            Components.load_default!
            @paths.each do |path|
              Components.load_from!(path)
            end

            # Run!
            RSpec::Core::Runner.run(args)
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
      end
    end
  end
end
