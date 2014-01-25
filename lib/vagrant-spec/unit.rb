# This file should be required as the base for all unit related
# tests. It configures the test runner as well if it can detect one.

require_relative "unit/isolated_environment"

if defined?(RSpec)
  # Define the rspec helpers for us and configure RSpec a bit
  require_relative "unit/rspec"
end
