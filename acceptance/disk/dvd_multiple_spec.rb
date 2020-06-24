shared_examples "provider/disk/dvd_multiple" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("disk_dvd_multiple")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "attaches multiple dvds" do
    status("Test: all optical drives should be attached")

    (0..3).each do |n|
      result = execute("vagrant", "ssh", "-c", "test -b /dev/sr#{n}")
      expect(result.exit_code).to eql(0)
    end
  end
end
