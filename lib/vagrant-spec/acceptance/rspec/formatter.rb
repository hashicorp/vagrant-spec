# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

require "rspec/core/formatters/documentation_formatter"

module Vagrant
  module Spec
    module Acceptance
      class Formatter < RSpec::Core::Formatters::DocumentationFormatter
        RSpec::Core::Formatters.register(
          self,
          :example_failed,
          :example_passed,
          :example_pending,
          :example_started,
          :message,
        )

        def example_failed(failed_example_notification)
          super
          @group_level -= 1
        end

        def example_passed(example_notification)
          super
          @group_level -= 1
        end

        def example_pending(example_notification)
          super
          @group_level -= 1
        end

        def example_started(example_notification)
          output.puts "#{current_indentation}#{example_notification.example.description.strip}"
          @group_level += 1
        end

        def message(message_notification)
          output.puts "#{current_indentation}#{message_notification.message}"
        end
      end
    end
  end
end
