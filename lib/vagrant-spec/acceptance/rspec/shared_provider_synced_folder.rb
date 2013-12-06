# This tests that synced folders work with a given provider.
shared_examples "provider/synced_folder" do |provider, options|
  if !options[:box_basic]
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("synced_folders")
    assert_execute("vagrant", "box", "add", "basic", options[:box_basic])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  # We put all of this in a single RSpec test so that we can test all
  # the cases within a single VM rather than having to `vagrant up` many
  # times.
  it "properly configures synced folder types" do
    status("Test: mounts the default /vagrant synced folder")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant/foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/hello$/)

    status("Test: doesn't mount a disabled folder")
    result = execute("vagrant", "ssh", "-c", "test -d /foo")
    expect(result).to exit_with(1)
  end
end
