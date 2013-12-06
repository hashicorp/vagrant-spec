shared_examples "provider/provisioner/shell" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("provisioner_shell")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "provisions with the shell script" do
    result = execute("vagrant", "ssh", "-c", "cat ~/foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/foo\n$/)
  end
end
