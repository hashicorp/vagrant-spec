shared_examples "provider/disk/dvd_multiple" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("disk_dvd_four")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "attaches multiple dvds", :skip_windows_guest do
    status("Test: all dvds should be attached")
    (0..3).each do |n|
      result = execute("vagrant", "ssh", "-c", "test -b /dev/sr#{n}")
      expect(result.exit_code).to eql(0)
    end

    status("Test: dvds should persist across a reload")
    assert_execute("vagrant", "reload")
    (0..3).each do |n|
      result = execute("vagrant", "ssh", "-c", "test -b /dev/sr#{n}")
      expect(result.exit_code).to eql(0)
    end

    status("Test: removing dvds")
    environment.skeleton("disk_dvd_two")
    assert_execute("vagrant", "reload")
    (0..1).each do |n|
      result = execute("vagrant", "ssh", "-c", "test -b /dev/sr#{n}")
      expect(result.exit_code).to eql(0)
    end
  end
end
