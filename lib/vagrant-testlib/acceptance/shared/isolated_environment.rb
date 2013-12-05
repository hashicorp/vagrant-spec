require "fileutils"
require "pathname"

require "log4r"
require "childprocess"

require "vagrant-testlib/isolated_environment"

module Vagrant
  module Testlib
    # This class extends the normal IsolatedEnvironment to add some
    # additional helpers for executing applications within that environment.
    class AcceptanceIsolatedEnvironment < IsolatedEnvironment
      def initialize(apps: nil, env: nil)
        super()

        @logger = Log4r::Logger.new("test::acceptance::isolated_environment")

        @apps = (apps || {}).dup
        @env  = (env || {}).dup

        # Set the home directory for any apps we execute
        @env["HOME"] = @homedir.to_s
      end

      # Executes a command in the context of this isolated environment.
      # Any command executed will therefore see our temporary directory
      # as the home directory.
      #
      # If the command has been defined with a special path, then the
      # command will be replaced with the full path to that command.
      def execute(command, *args, **options)
        # Create the command
        command = replace_command(command)

        # Create the child process that executes the command
        process = ChildProcess.build(command, *args)
        process.cwd = @workdir.to_s
        @env.each do |k, v|
          process.environment[k] = v
        end

        # TODO(mitchellh): need the output
        process.start
        process.wait
      end

      # This replaces a command with a replacement defined when this
      # isolated environment was initialized. If nothing was defined,
      # then the command itself is returned.
      def replace_command(command)
        return @apps[command] if @apps.has_key?(command)
        return command
      end
    end
  end
end
