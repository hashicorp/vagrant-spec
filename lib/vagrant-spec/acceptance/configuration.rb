require "vagrant-spec"

module Vagrant
  module Spec
    module Acceptance
      # Configuration is the configuration for the Vagrant spec
      # acceptance tests.
      class Configuration
        # Paths to various components. This by default contains the
        # built-in components. You should _append_ to this to add more
        # paths.
        attr_accessor :component_paths

        # Additional environmental variables to set for environments.
        attr_reader :env

        # The providers that are configured to be used.
        attr_reader :providers

        # Paths to folders containing "skeletons" for the tests. This
        # doesn't really need to be set unless you have custom tests.
        attr_accessor :skeleton_paths

        # The path to the `vagrant` executable to test. If not specified,
        # this defaults to "vagrant" and it is up to the shell to expand
        # this to whatever is on the PATH.
        attr_accessor :vagrant_path

        def initialize
          @component_paths = [
            Vagrant::Spec.source_root.join("acceptance"),
          ]

          @env            = {}
          @providers      = {}
          @skeleton_paths = []
          @vagrant_path   = "vagrant"
        end

        # Tells vagrant-spec to acceptance test a certain provider.
        #
        # The order in which this is called has no effect on the order
        # that the tests will actually run in, at the moment.
        #
        # One of the keyword arguments accepted by this is "features" which
        # can be a list of features supported by the provider. If the feature
        # is prefixed with a "!" then that feature is _not_ supported. Currently
        # valid options and their defaults:
        #
        #   * "halt" (default: supported) - `vagrant halt` and `vagrant up`
        #     from halt work with this provider.
        #   * "suspend" (default: supported) - `vagrant suspend` and
        #     `vagrant resume` work with this provider.
        #
        # @option options [String] :box Path to a compatible "box" file
        #   for this provider that can be used for tests.
        # @option options [Array<String>] :features List of features that
        #   are or are not supported by this provider. See the list above
        #   for the feature list.
        def provider(name, **options)
          options[:features] ||= []
          options[:features].map(&:to_s)
          @providers[name.to_s] = options
        end
      end
    end
  end
end
