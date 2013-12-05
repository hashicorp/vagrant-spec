require "rspec"

module Vagrant
  module Spec
    # The runner configures RSpec to run the given components.
    class Runner
      def self.run(components)
        args = ["--format=d",
                "--color",]

        RSpec::Core::Runner.run(args)
      end
    end
  end
end
