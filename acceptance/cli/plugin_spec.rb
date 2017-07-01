require "tempfile"

require "vagrant-spec"

describe "vagrant CLI: plugin", component: "cli/plugin" do
  include_context "acceptance"

  it "has no plugins by default" do
    result = execute("vagrant", "plugin", "list")
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(:plugin_list_none)
  end

  it "has certain behavior with a plugin installed" do
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

    status("Test: plugin should load")
    result = execute("vagrant", "vshb")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/I HAVE BEEN EXECUTED/)

    status("Test: plugin can be uninstalled")
    result = execute("vagrant", "plugin", "uninstall", "vagrant-spec-helper-basic")
    expect(result).to exit_with(0)

    status("Test: should no longer have any plugins")
    result = execute("vagrant", "plugin", "list")
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(:plugin_list_none)
  end

  it "can install and uninstall multiple plugins" do
    status("Test: plugin installation")
    paths = [
      Vagrant::Spec.acceptance_plugin_path.
        join("vagrant-spec-helper-basic-0.1.0.gem").to_s,
      Vagrant::Spec.acceptance_plugin_path.
        join("vagrant-spec-helper-basic-rename-0.1.0.gem").to_s,
    ]
    result = execute("vagrant", "plugin", "install", *paths)
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(
      :plugin_installed, "vagrant-spec-helper-basic", "0.1.0")
    expect(result.stdout).to match_output(
      :plugin_installed, "vagrant-spec-helper-basic-rename", "0.1.0")

    status("Test: plugin shows up in list")
    result = execute("vagrant", "plugin", "list")
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(
      :plugin_list_plugin, "vagrant-spec-helper-basic", "0.1.0")
    expect(result.stdout).to match_output(
      :plugin_list_plugin, "vagrant-spec-helper-basic-rename", "0.1.0")

    status("Test: plugins can be uninstalled")
    result = execute("vagrant", "plugin", "uninstall",
      "vagrant-spec-helper-basic", "vagrant-spec-helper-basic-rename")
    expect(result).to exit_with(0)

    status("Test: should no longer have any plugins")
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

    it "succeeds with a remote plugin" do
      name = "vagrant-spec-helper-basic"
      result = execute("vagrant", "plugin", "install", name)
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(
        :plugin_installed, name, "0.2.0")
    end

    it "can install a specific version of a plugin" do
      name = "vagrant-spec-helper-basic"
      result = execute("vagrant", "plugin", "install", name, "--plugin-version", "0.1.0")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(
        :plugin_installed, name, "0.1.0")
    end
  end

  describe "plugin update" do
    it "can update a plugin" do
      name = "vagrant-spec-helper-basic"

      status("Test: install low version of plugin")
      result = execute("vagrant", "plugin", "install", name, "--plugin-version", "0.1.0")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(
        :plugin_installed, name, "0.1.0")

      status("Test: update the plugin")
      result = execute("vagrant", "plugin", "update", name)
      expect(result).to exit_with(0)

      status("Test: plugin shows up in list")
      result = execute("vagrant", "plugin", "list")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(
        :plugin_list_plugin, name, "0.2.0")
    end
  end

  describe "plugin license" do
    let(:name) { "vagrant-spec-helper-basic" }
    let(:tempfile) { Tempfile.new("vagrant-spec") }

    before do
      path = Vagrant::Spec.acceptance_plugin_path.join("vagrant-spec-helper-basic-0.1.0.gem")
      result = execute("vagrant", "plugin", "install", path.to_s)
      expect(result).to exit_with(0)

      tempfile.puts("HELLO")
      tempfile.close
    end

    it "fails with a license file that doesn't exist" do
      result = execute("vagrant", "plugin", "license", name, "/i/should/not/exist")
      expect(result).to exit_with(1)
    end

    it "fails with a plugin that isn't installed" do
      result = execute("vagrant", "plugin", "license", "i-am-not-installed", tempfile.path)
      expect(result).to exit_with(1)
    end

    it "succeeds with a valid gem and license" do
      result = execute("vagrant", "plugin", "license", name, tempfile.path)
      expect(result).to exit_with(0)

      f = environment.homedir.join("license-#{name}.lic")
      expect(f).to be_file
      expect(f.read).to eql("HELLO\n")
    end
  end

  describe "plugin extensions" do
    it "should install nokogiri" do
      result = execute("vagrant", "plugin", "install", "nokogiri")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:plugin_installed, "nokogiri", nil)
    end
  end
end
