# The RSpec helpers
require_relative "rspec/context"
require_relative "rspec/formatter"
require_relative "rspec/matcher_exit_with"
require_relative "rspec/matcher_match_output"

RSpec.configure do |c|
  c.add_formatter Vagrant::Spec::Acceptance::Formatter

  if ENV["VAGRANT_SPEC_GUEST_PLATFORM"].to_s == "windows"
    c.filter_run_excluding :skip_windows_guest
  end

  if RUBY_PLATFORM.match(/linux/)
    c.filter_run_excluding :skip_linux_hosts
  end
end
