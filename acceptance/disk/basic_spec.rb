shared_examples "provider/disk/basic" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("disk_basic")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "configures storage mediums", :skip_windows_guest do
    status("Test: primary disk is resized")
    result = execute("vagrant", "ssh", "-c", "sudo blockdev --getsize64 /dev/sda")
    expect(result.exit_code).to eql(0)
    expect(result.stdout).to match(/69793218560$/)

    status("Test: secondary disk is attached")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sdb")
    expect(result.exit_code).to eql(0)

    status("Test: dvd is attached")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sr0")
    expect(result.exit_code).to eql(0)

    status("Test: configuration should persist across a reload")
    assert_execute("vagrant", "reload")

    status("Test: primary disk is unchanged")
    result = execute("vagrant", "ssh", "-c", "sudo blockdev --getsize64 /dev/sda")
    expect(result.stdout).to match(/69793218560$/)

    status("Test: secondary disk is attached")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sdb")
    expect(result.exit_code).to eql(0)

    status("Test: dvd is attached")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sr0")
    expect(result.exit_code).to eql(0)

    status("Test: removing disk configuration")
    environment.skeleton("disk_empty")
    assert_execute("vagrant", "reload")

    status("Test: primary disk is unchanged")
    result = execute("vagrant", "ssh", "-c", "sudo blockdev --getsize64 /dev/sda")
    expect(result.stdout).to match(/69793218560$/)

    status("Test: secondary disk is removed")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sdb")
    expect(result.exit_code).to eql(1)

    status("Test: dvd is removed")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sr0")
    expect(result.exit_code).to eql(1)
  end
end

