require "vagrant-spec/acceptance"

describe "vagrant version", component: "vagrant/core" do
  include_context "acceptance"

  it "prints the version when called with '-v'" do
    result = execute("vagrant", "-v")
    expect(result.stdout).to match_output(:version)
  end

  it "prints the version when called with '--version'" do
    result = execute("vagrant", "--version")
    expect(result.stdout).to match_output(:version)
  end
end
