shared_examples "provider/triggers/advanced" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    assert_execute("vagrant", "box", "add", "box", options[:box])
  end

  after(:each) do
    execute("vagrant", "destroy", "--force", log: false)
  end

  context "machine-box" do
    before do
      environment.skeleton("triggers-advanced")
    end

    it "does not fail if a trigger fails but is configured to continue on" do
      result = execute("vagrant", "up", "machine-box", "--provider=#{provider}")
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/I'm going to fail/)
      expect(result.stdout).to match(/Does not exist/)
    end

    it "runs a remote script" do
      result = execute("vagrant", "up", "machine-box", "--provider=#{provider}")
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/Hello there from machine-box.local/)
    end

    it "does not run a trigger on :destroy" do
      result = execute("vagrant", "up", "machine-box", "--provider=#{provider}")
      destroy_result = execute("vagrant", "destroy", "machine-box", "-f")
      expect(destroy_result).to exit_with(0)
      expect(destroy_result.stdout).not_to match(/Before the action!/)
    end
  end

  context "spec-box" do
    before do
      environment.skeleton("triggers-advanced")
    end

    it "only runs the guest trigger for spec-box and not machine-box" do
      result = execute("vagrant", "up", "spec-box", "--provider=#{provider}")
      machine_result = execute("vagrant", "up", "machine-box", "--provider=#{provider}")
      expect(result).to exit_with(0)
      expect(machine_result).to exit_with(0)
      expect(result.stdout).to match(/Only spec-box/)
      expect(machine_result.stdout).not_to match(/Only spec-box/)
    end
  end
end
