# The RSpec helpers
require_relative "rspec/context"
require_relative "rspec/formatter"
require_relative "rspec/matcher_match_output"
require_relative "rspec/shared_provider_basic"
require_relative "rspec/shared_provider_synced_folder"

RSpec.configure do |c|
  c.add_formatter Vagrant::Spec::Acceptance::Formatter
end
