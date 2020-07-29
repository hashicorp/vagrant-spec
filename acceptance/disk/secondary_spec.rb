shared_examples "provider/disk/secondary" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("disk_secondary")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "configures a secondary disk", :skip_windows_guest do
    status("Test: secondary disk should be attached")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sdb")
    expect(result.exit_code).to eql(0)

    status("Test: secondary disk should be target size")
    environment.skeleton("disk_secondary_bigger")
    assert_execute("vagrant", "reload")
    result = execute("vagrant", "ssh", "-c", "sudo blockdev --getsize64 /dev/sdb")
    expect(result.stdout).to match(/134217728$/)

    status("Test: secondary disk should disappear")
    environment.skeleton("disk_empty")
    assert_execute("vagrant", "reload")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sdb")
    expect(result.exit_code).to eql(1)
  end
end

