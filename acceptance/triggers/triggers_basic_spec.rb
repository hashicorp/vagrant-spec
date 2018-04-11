shared_examples "provider/triggers" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("triggers-basic")
    assert_execute("vagrant", "box", "add", "box", options[:box])
    #assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  it "prints a message before and after up" do
    result = execute("vagrant", "up", "--provider=#{provider}")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/Acceptance/)
    expect(result.stdout).to match(/Testing 1 2 3.../)
    expect(result.stdout).to match(/Hello before up/)
    expect(result.stdout).to match(/Hello after up/)
  end

  it "prints a message before and after destroy" do
    result = execute("vagrant", "destroy", "-f")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/DESTROY!!/)
    expect(result.stdout).to match(/Destroyed/)
    expect(result.stdout).to match(/Testing 1 2 3.../)
    expect(result.stdout).to match(/Hello before destroy/)
    expect(result.stdout).to match(/Hello after destroy/)
  end
end
