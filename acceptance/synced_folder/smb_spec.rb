shared_examples "provider/synced_folder/smb" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("synced_folder_smb")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  # SMB is not supported for linux hosts
  it "properly configures SMB", :skip_linux_hosts do
    status("Test: does initial smb sync")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-smb/foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/hello$/)

    status("Test: doesn't mount a disabled folder")
    result = execute("vagrant", "ssh", "-c", "test -d /foo")
    expect(result.exit_code).to eql(1)

    status("Test: persists a sync folder after a manual reboot")
    result = execute("vagrant", "ssh", "-c", "sudo reboot")
    expect(result).to exit_with(255)
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-smb/foo")
    expect(result.exit_code).to eql(0)
    expect(result.stdout).to match(/hello$/)

    status("Test: persists a sync folder after a provisioner reboot")
    result = execute("vagrant", "provision", "--provision-with", "reboot")
    expect(result.exit_code).to eql(0)
    sleep 10
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-smb/foo")
    expect(result.exit_code).to eql(0)
    expect(result.stdout).to match(/hello$/)
  end
end
