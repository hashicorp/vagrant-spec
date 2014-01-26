# This file should be required as the base for all unit related
# tests. It configures the test runner as well if it can detect one.

require_relative "unit/dummy_provider"
require_relative "unit/isolated_environment"

if defined?(RSpec)
  # Define the rspec helpers for us and configure RSpec a bit
  require_relative "unit/rspec"
end

# Configure VAGRANT_CWD so that the tests never find an actual
# Vagrantfile anywhere, or at least this minimizes those chances.
ENV["VAGRANT_CWD"] = Dir.mktmpdir("vagrant")

# Set the dummy provider to the default for tests
ENV["VAGRANT_DEFAULT_PROVIDER"] = "dummy"
