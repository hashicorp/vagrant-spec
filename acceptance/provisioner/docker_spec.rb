shared_examples "provider/provisioner/docker" do |provider, options|
  box = options[:box_docker] || options[:box]
  if !box
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("provisioner_docker")
    assert_execute("vagrant", "box", "add", "box", box)
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "provisions with and installs docker" do
    status("Test: installs docker")
    result = execute("vagrant", "ssh", "-c", "which docker")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/docker/)
  end
end
