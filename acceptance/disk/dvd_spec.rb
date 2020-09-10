shared_examples "provider/disk/dvd" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("disk_dvd")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "attaches and removes an optical drive", :skip_windows_guest do
    status("Test: drive is attached")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sr0")
    expect(result.exit_code).to eql(0)

    status("Test: drive is removed")
    environment.skeleton("disk_empty")
    assert_execute("vagrant", "reload")
    result = execute("vagrant", "ssh", "-c", "test -b /dev/sr0")
    expect(result.exit_code).to eql(1)
  end
end

