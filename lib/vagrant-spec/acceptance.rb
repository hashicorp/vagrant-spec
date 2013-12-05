# This file should be required as the base for all acceptance related
# tests. It configures the test runner as well if it can detect one.

require_relative "acceptance/configuration"
require_relative "acceptance/isolated_environment"
require_relative "acceptance/output"

if defined?(RSpec)
  # Define the rspec helpers for us and configure RSpec a bit
  require_relative "acceptance/rspec"
end

module Vagrant
  module Spec
    module Acceptance
      # This returns the configuration for the acceptance tests.
      #
      # @return [Configuration]
      def self.config
        @config ||= Configuration.new
      end

      # This allows users to configure the acceptance tests.
      def self.configure
        yield config
      end
    end
  end
end
