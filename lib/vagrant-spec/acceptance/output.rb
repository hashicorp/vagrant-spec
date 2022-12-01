# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module Vagrant
  module Spec
    # OutputTester tests text for output by checking against a global
    # registry of testers in the $output global variable. If the tester
    # returns true, then it matches, otherwise it doesn't match.
    #
    # Additional testers can be added to the $output global hash. They
    # should be callables that take at least one argument: the text to check.
    # They can take additional arguments that will just be forwarded through
    # if they're passed to {matches?}.
    class OutputTester
      @@testers = {}

      # Tests if the output tester with the name "name" matches the given
      # text.
      #
      # @return [Boolean]
      def self.matches?(text, name, *args)
        callable = @@testers[name]
        if !callable
          raise ArgumentError, "Unknown output matcher: #{name}"
        end

        callable.call(text, *args)
      end

      # Add a tester.
      def self.[]=(key, value)
        @@testers[key] = value
      end

      # Delete a tester by name.
      def self.delete(key)
        @@testers.delete(key)
      end
    end
  end
end
