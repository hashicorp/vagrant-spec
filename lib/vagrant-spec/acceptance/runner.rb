# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

require "set"

require "rspec"

module Vagrant
  module Spec
    module Acceptance
      # The runner configures RSpec to run the given components.
      class Runner
        def initialize(paths: nil)
          @components = Components.new(paths || [])
          prepare_components!
        end

        def components
          @components.components
        end

        def run(components, **opts)
          components = Set.new(components || [])
          without_components = Set.new(opts[:without_components] || [])

          args = [
            "--color",
            "--format", "Vagrant::Spec::Acceptance::Formatter",
          ]
          args += ["--example", opts[:example]] if opts[:example]

          # Filter out the components
          if !components.empty? || !without_components.empty?
            bad = []
            RSpec.world.example_groups.each do |g|
              next if !g.metadata.has_key?(:component)
              if !components.empty? && components.none?{|pattern| File.fnmatch?(pattern, g.metadata[:component])}
                bad << g
              else
                if without_components.any?{|pattern| File.fnmatch?(pattern, g.metadata[:component])}
                  bad << g
                end
              end
            end

            bad.each do |b|
              puts "Skipping: #{b.metadata[:component]}"
              RSpec.world.example_groups.delete(b)
            end
          end

          RSpec::Core::Runner.run(args)
        end

        protected

        def prepare_components!
          # Define the provider example group
          Acceptance.config.providers.each do |name, opts|
            @components.provider_features.each do |feature|
              component = "provider/#{name}/#{feature}"

              g = RSpec::Core::ExampleGroup.describe(
                component, component: component)

              # Include any extra contexts defined
              (opts[:contexts] || []).each do |context|
                g.include_context(context)
              end

              g.it_should_behave_like("provider/#{feature}", name, opts)
            end
          end
        end

      end
    end
  end
end
