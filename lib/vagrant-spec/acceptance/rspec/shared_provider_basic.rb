# This tests the basic functionality of a provider: that it can run
# a machine, provide SSH access, and destroy that machine.
shared_examples "provider/basic" do |provider, options|
  if !options[:box_basic]
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  it "can bring the machine up, ssh, and destroy it" do
    assert_execute("vagrant", "box", "add", "basic", options[:box_basic])
    assert_execute("vagrant", "init", "basic")
    assert_execute("vagrant", "up", "--provider=#{provider}")

    result = execute("vagrant", "ssh", "-c", "echo foo")
    expect(result.exit_code).to eql(0)
    expect(result.stdout).to match(/foo\n$/)

    assert_execute("vagrant", "destroy", "--force")
  end
end
