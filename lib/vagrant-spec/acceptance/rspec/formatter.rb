require "rspec/core/formatters/documentation_formatter"

module Vagrant
  module Spec
    module Acceptance
      class Formatter < RSpec::Core::Formatters::DocumentationFormatter
        def example_failed(example)
          super
          @group_level -= 1
        end

        def example_passed(example)
          super
          @group_level -= 1
        end

        def example_pending(example)
          super
          @group_level -= 1
        end

        def example_started(example)
          output.puts "#{current_indentation}#{example.description.strip}"
          @group_level += 1
        end

        def message(message)
          output.puts "#{current_indentation}#{message}"
        end
      end
    end
  end
end
