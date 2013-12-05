module Vagrant
  module Spec
    module Acceptance
    # Configuration is the configuration for the Vagrant spec
      # acceptance tests.
      class Configuration
        # Additional environmental variables to set for environments.
        attr_reader :env

        # The path to the `vagrant` executable to test. If not specified,
        # this defaults to "vagrant" and it is up to the shell to expand
        # this to whatever is on the PATH.
        attr_accessor :vagrant_path

        def initialize
          @env          = {}
          @vagrant_path = "vagrant"
        end
      end
    end
  end
end
