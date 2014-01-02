# This tests that packaging works with a given provider.
shared_examples "provider/package" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  it "can't package before an up" do
    expect(execute("vagrant", "package")).to exit_with(1)
  end

  context "with a running machine" do
    before do
      assert_execute("vagrant", "box", "add", "box", options[:box])
      assert_execute("vagrant", "init", "box")
      assert_execute("vagrant", "up", "--provider=#{provider}")
    end

    after do
      # Just always do this just in case
      execute("vagrant", "destroy", "--force", log: false)
    end

    it "can package" do
      expect(execute("vagrant", "package")).to exit_with(0)

      path = environment.workdir.join("package.box")
      expect(path).to be_file
    end
  end
end
