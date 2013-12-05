# This file should be required as the base for all acceptance related
# tests. It configures the test runner as well if it can detect one.

# The RSpec helpers
require_relative "acceptance/shared/rspec/matcher_match_output"

# Setup the output global variable. This will track all the registered
# outputtable strings.
$vagrant_output = {}
require_relative "acceptance/output/version"

# The actual test cases
require_relative "acceptance/core/version_test"

RSpec.configure do |c|

end
