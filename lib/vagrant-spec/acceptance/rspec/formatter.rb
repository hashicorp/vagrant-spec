require "rspec/core/formatters/documentation_formatter"

module Vagrant
  module Spec
    module Acceptance
      class Formatter < ::RSpec::Core::Formatters::DocumentationFormatter
        RSpec::Core::Formatters.register self,
          :example_group_started, :example_group_finished,
          :example_passed, :example_pending, :example_failed

        def message(notification)
          output.puts "  #{current_indentation}#{notification.message}"
        end
      end
    end
  end
end
