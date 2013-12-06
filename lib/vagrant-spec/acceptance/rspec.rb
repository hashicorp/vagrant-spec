# The RSpec helpers
require_relative "rspec/context"
require_relative "rspec/formatter"
require_relative "rspec/matcher_match_output"

RSpec.configure do |c|
  c.add_formatter Vagrant::Spec::Acceptance::Formatter
end
