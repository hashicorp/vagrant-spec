require "rspec"
require "thor"

require "vagrant-spec/acceptance"
require "vagrant-spec/acceptance/runner"
require "vagrant-spec/components"

module Vagrant
  module Spec
    # This is the CLI that implements the "vagrant-spec" command.
    class CLI < Thor
      option :config, type: :string, default: "vagrant-spec.config.rb", desc: "path to config file to load"
      desc "components", "output the components that can be tested"
      def components
        load_config

        runner = Acceptance::Runner.new(paths: Acceptance.config.component_paths)
        runner.components.sort.each do |c|
          puts c
        end
      end

      option :components, type: :array, desc: "components to test. defaults to all"
      option :without_components, type: :array, desc: "components to not test"
      option :config, type: :string, default: "vagrant-spec.config.rb", desc: "path to config file to load"
      option :example, type: :string, default: nil, desc: "specific example to run"
      desc "test", "runs the specs"
      def test
        load_config

        Acceptance::Runner.new(paths: Acceptance.config.component_paths).
          run(options[:components], example: options[:example], without_components: options[:without_components])
      end

      protected

      def load_config
        load options[:config]
      rescue LoadError => e
        $stderr.puts "Please create a vagrant-spec.config.rb file."
        if ENV.fetch("DEBUG", "0").to_s != "0"
          $stderr.puts "#{e.class}: #{e}\n#{e.backtrace.join("\n")}"
        end
        exit 1
      end
    end
  end
end
