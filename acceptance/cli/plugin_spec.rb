require "vagrant-spec"

describe "vagrant CLI: plugin", component: "cli/plugin" do
  include_context "acceptance"

  it "has no plugins by default" do
    result = execute("vagrant", "plugin", "list")
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(:plugin_list_none)
  end

  describe "plugin install" do
    it "fails with a plugin that doesn't exist" do
      name = "vagrant-spec-nope-#{Time.now.to_i}"
      result = execute("vagrant", "plugin", "install", name)
      expect(result).to exit_with(1)
      expect(result.stderr).to match_output(:plugin_install_not_found, name)
    end

    it "succeeds in installing a local plugin" do
      status("Test: plugin installation")
      path = Vagrant::Spec.acceptance_plugin_path.join("vagrant-spec-helper-basic-0.1.0.gem")
      result = execute("vagrant", "plugin", "install", path.to_s)
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(
        :plugin_installed, "vagrant-spec-helper-basic", "0.1.0")

      status("Test: plugin shows up in list")
      result = execute("vagrant", "plugin", "list")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(
        :plugin_list_plugin, "vagrant-spec-helper-basic", "0.1.0")
    end
  end
end
