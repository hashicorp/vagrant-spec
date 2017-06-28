shared_examples "provider/network/private_network" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  let(:port){ (rand * 1000).floor + 9000 }

  before do
    environment.skeleton("network_private_network")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "properly configures private networks" do
    status("Test: static IP")
    assert_network("http://192.168.33.10:#{port}/", port)
  end
end
