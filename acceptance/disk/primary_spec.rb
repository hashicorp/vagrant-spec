shared_examples "provider/disk/primary" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("disk_primary")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "configures the primary disk", :skip_windows_guest do
    status("Test: primary disk should be attached")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sda")
    expect(result.exit_code).to eql(0)

    status("Test: primary disk should grow to target size")
    environment.skeleton("disk_primary_bigger")
    assert_execute("vagrant", "reload")
    result = execute("vagrant", "ssh", "-c", "sudo blockdev --getsize64 /dev/sda")
    expect(result.stdout).to match(/69793218560$/)

    status("Test: primary disk is not removed")
    environment.skeleton("disk_empty")
    assert_execute("vagrant", "reload")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sda")
    expect(result.exit_code).to eql(0)
  end
end

