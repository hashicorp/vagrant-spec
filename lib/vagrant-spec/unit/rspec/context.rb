# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

require "tempfile"
require "tmpdir"

require "vagrant-spec/unit/isolated_environment"

shared_context "vagrant-unit" do
  before(:each) do
    # State to store the list of registered plugins that we have to
    # unregister later.
    @_plugins = []

    # Create a thing to store our temporary files so that they aren't
    # unlinked right away.
    @_temp_files = []
  end

  after(:each) do
    # Unregister each of the plugins we have may have temporarily
    # registered for the duration of this test.
    @_plugins.each do |plugin|
      Vagrant.plugin("1").manager.unregister(plugin)
      Vagrant.plugin("2").manager.unregister(plugin)
    end
  end

  # This creates an isolated environment so that Vagrant doesn't
  # muck around with your real system during unit tests.
  #
  # The returned isolated environment has a variety of helper
  # methods on it to easily create files, Vagrantfiles, boxes,
  # etc.
  def isolated_environment
    Vagrant::Spec::UnitIsolatedEnvironment.new.tap do |env|
      yield env if block_given?
    end
  end

  # This registers a Vagrant plugin for the duration of a single test.
  # This will yield a new plugin class that you can then call the
  # public plugin methods on.
  #
  # @yield [plugin] Yields the plugin class for you to call the public
  #   API that you need to.
  def register_plugin(version=nil)
    version ||= Vagrant::Config::CURRENT_VERSION
    plugin = Class.new(Vagrant.plugin(version))
    plugin.name("Test Plugin #{plugin.inspect}")
    yield plugin if block_given?
    @_plugins << plugin
    plugin
  end

  # This helper creates a temporary file and returns a Pathname
  # object pointed to it.
  #
  # @return [Pathname]
  def temporary_file(contents=nil)
    f = Tempfile.new("vagrant-unit")

    if contents
      f.write(contents)
      f.flush
    end

    # Store the tempfile in an instance variable so that it is not
    # garbage collected, so that the tempfile is not unlinked.
    @_temp_files << f

    return Pathname.new(f.path)
  end

  # This creates a temporary directory and returns a {Pathname}
  # pointing to it.
  #
  # @return [Pathname]
  def temporary_dir
    # Create a temporary directory and append it to the instance
    # variabe so that it isn't garbage collected and deleted
    d = Dir.mktmpdir("vagrant")
    @_temp_files << d

    # Return the pathname
    return Pathname.new(d)
  end

  # This helper provides temporary environmental variable changes.
  def with_temp_env(environment)
    # Build up the new environment, preserving the old values so we
    # can replace them back in later.
    old_env = {}
    environment.each do |key, value|
      old_env[key] = ENV[key]
      ENV[key]     = value
    end

    # Call the block, returning its return value
    return yield
  ensure
    # Reset the environment no matter what
    old_env.each do |key, value|
      ENV[key] = value
    end
  end
end
