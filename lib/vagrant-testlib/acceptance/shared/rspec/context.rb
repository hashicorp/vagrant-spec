require "vagrant-testlib/acceptance/shared/isolated_environment"

shared_context "acceptance" do
  # Setup the environment so that we have an isolated area
  # to run Vagrant. We do some configuration here as well in order
  # to replace "vagrant" with the proper path to Vagrant as well
  # as tell the isolated environment about custom environmental
  # variables to pass in.
  let!(:environment) { new_environment }

  after(:each) do
    environment.close
  end

  # Creates a new isolated environment instance each time it is called.
  #
  # @return [Acceptance::IsolatedEnvironment]
  def new_environment(env=nil)
    apps = { "vagrant" => config.vagrant_path }
    env  = config.env.merge(env || {})

    Vagrant::Testlib::AcceptanceIsolatedEnvironment.new(apps, env)
  end

  # Executes the given command in the context of the isolated environment.
  #
  # @return [Object]
  def execute(*args, &block)
    environment.execute(*args, &block)
  end

  # This method is an assertion helper for asserting that a process
  # succeeds. It is a wrapper around `execute` that asserts that the
  # exit status was successful.
  def assert_execute(*args, &block)
    result = execute(*args, &block)
    assert(result.exit_code == 0, "expected '#{args.join(" ")}' to succeed")
    result
  end
end
