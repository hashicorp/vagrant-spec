shared_examples "provider/synced_folder/rsync" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("synced_folder_rsync")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "properly syncs using rsync" do
    status("Test: does initial rsync sync")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-rsync/foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/hello$/)

    status("Test: doesn't mount a disabled folder")
    result = execute("vagrant", "ssh", "-c", "test -d /foo")
    expect(result.exit_code).to eql(1)

    status("Test: syncs changes when requested")
    environment.workdir.join("bar").open("w+") do |f|
      f.write("goodbye")
    end
    assert_execute("vagrant", "rsync")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-rsync/bar")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/goodbye$/)
  end
end
