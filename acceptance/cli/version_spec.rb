describe "vagrant CLI: version", component: "cli/version" do
  include_context "acceptance"

  it "prints the version when called with '-v'" do
    result = execute("vagrant", "-v")
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(:version)
  end

  it "prints the version when called with '--version'" do
    result = execute("vagrant", "--version")
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(:version)
  end
end
