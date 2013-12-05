# This file should be required as the base for all acceptance related
# tests. It configures the test runner as well if it can detect one.

require_relative "acceptance/isolated_environment"
require_relative "acceptance/output"

if defined?(RSpec)
  # Define the rspec helpers for us and configure RSpec a bit
  require_relative "acceptance/rspec"
end
