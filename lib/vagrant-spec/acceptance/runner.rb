require "set"

require "rspec"

module Vagrant
  module Spec
    module Acceptance
      # The runner configures RSpec to run the given components.
      class Runner
        def initialize(paths: nil)
          @world = RSpec::Core::World.new
          @components = Components.new(@world, paths || [])
        end

        def components
          @components.components
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

          # Set the world
          old_world = RSpec.world
          RSpec.world = @world

          # Load the components
          @components.reload!

          # Define the provider example group
          Acceptance.config.providers.each do |name, opts|
            features = ["basic", "synced_folder"]

            features.each do |feature|
              component = "provider/#{name}/#{feature}"

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

          # Filter out the components
          if !components.empty?
            bad = []
            @world.example_groups.each do |g|
              next if !g.metadata.has_key?(:component)
              bad << g if !components.include?(g.metadata[:component])
            end

            bad.each do |b|
              puts "Skipping: #{b.metadata[:component]}"
              @world.example_groups.delete(b)
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
