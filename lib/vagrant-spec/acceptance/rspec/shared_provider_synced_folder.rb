# This tests that synced folders work with a given provider.
shared_examples "provider/synced_folder" do |provider, options|
  if !options[:box_basic]
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  # Spin up a single VM to test all the synced folder configuration
  # for speed. Besides, its a good test to make sure they all work
  # together.
  around(:all) do |example|
    begin
      environment.skeleton("synced_folders")

      assert_execute("vagrant", "box", "add", "basic", options[:box_basic])
      assert_execute("vagrant", "init", "basic")
      assert_execute("vagrant", "up", "--provider=#{provider}")

      example.run

      assert_execute("vagrant", "destroy", "--force")
    ensure
      # Just do a destroy to be safe, but don't worry about the output
      # and don't log it.
      execute("vagrant", "destroy", "--force")
    end
  end

  it "mounts the default /vagrant synced folder" do
    result = execute("vagrant", "ssh", "-c", "cat /vagrant/foo")
    expect(result.exit_code).to eql(0)
    expect(result.stdout).to match(/hello\n$/)
  end

  it "doesn't mount a disabled folder" do
    result = execute("vagrant", "ssh", "-c", "test -d /foo")
    expect(result.exit_code).to eql(1)
  end
end
