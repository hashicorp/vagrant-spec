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

  it "properly configures SMB" do
    status("Test: does initial smb sync")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-smb/foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/hello$/)

    status("Test: doesn't mount a disabled folder")
    result = execute("vagrant", "ssh", "-c", "test -d /foo")
    expect(result.exit_code).to eql(1)
  end
end
