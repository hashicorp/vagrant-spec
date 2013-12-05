require "set"

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

        def components
          with_world do
            Components.components
          end
        end

        def run(components)
          args = [
            "--color",
            "--format", "Vagrant::Spec::Acceptance::Formatter",
          ]

          with_world(components) do
            RSpec::Core::Runner.run(args)
          end
        end

        protected

        def with_world(components=nil)
          components = Set.new(components || [])

          # Reset the world so we don't have any components
          @world.example_groups.clear

          # Set the world
          old_world = RSpec.world
          RSpec.world = @world

          # Load the components
          Components.load_default!
          @paths.each do |path|
            Components.load_from!(path)
          end

          # Define the provider example group
          Acceptance.config.providers.each do |name, opts|
            features = ["basic"]

            features.each do |feature|
              component = "provider/#{name}/#{feature}"
              if !components.empty? && !components.include?(component)
                puts "Skipping component: #{component}"
                next
              end

              g = RSpec::Core::ExampleGroup.describe(
                component, component: component)

              # Include any extra contexts defined
              (opts[:contexts] || []).each do |context|
                g.include_context(context)
              end

              g.it_should_behave_like("provider/#{feature}", name, opts)
              g.register
            end
          end

          yield
        ensure
          RSpec.world = old_world
        end
      end
    end
  end
end
