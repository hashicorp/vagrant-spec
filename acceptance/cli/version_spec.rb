require "vagrant-spec/acceptance"

describe "vagrant CLI basics", component: "cli" do
  include_context "acceptance"

  describe "vagrant version" do
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
end
