require "fileutils"
require "pathname"
require "tmpdir"

module Vagrant
  module Spec
    # This class manages an isolated environment for Vagrant to
    # run in. It creates a temporary directory to act as the
    # working directory as well as sets a custom home directory.
    #
    # This is a base class that is shared among unit and acceptance tests.
    # Each type of tests adds its own methods to interact with this
    # environment.
    class IsolatedEnvironment
      attr_reader :homedir
      attr_reader :workdir

      # Initializes an isolated environment. You can pass in some
      # options here to configure runing custom applications in place
      # of others as well as specifying environmental variables.
      #
      # @param [Hash] apps A mapping of application name (such as "vagrant")
      #   to an alternate full path to the binary to run.
      # @param [Hash] env Additional environmental variables to inject
      #   into the execution environments.
      def initialize
        # Create a temporary directory for our work
        @tempdir = Pathname.new(Dir.mktmpdir)

        # Setup the home and working directories
        @homedir = @tempdir.join("home")
        @workdir = @tempdir.join("work")

        @homedir.mkdir
        @workdir.mkdir
      end

      # This closes the environment by cleaning it up.
      def close
        FileUtils.rm_rf(@tempdir)
      end
    end
  end
end
