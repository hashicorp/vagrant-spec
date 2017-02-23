describe "vagrant CLI: init", component: "cli/init" do
  include_context "acceptance"

  it "creates a Vagrantfile in the working directory" do
    vagrantfile = environment.workdir.join("Vagrantfile")
    expect(vagrantfile.exist?).to_not be(true)

    assert_execute("vagrant", "init")
    expect(vagrantfile.exist?).to be(true)
  end

  it "creates a Vagrantfile with the box set to the given argument" do
    vagrantfile = environment.workdir.join("Vagrantfile")

    assert_execute("vagrant", "init", "foo")
    vagrantfile.read.should match(/config.vm.box = "foo"$/)
  end

  it "creates a Vagrantfile with the box URL set to the given argument" do
    vagrantfile = environment.workdir.join("Vagrantfile")

    assert_execute("vagrant", "init", "foo", "bar")

    contents = vagrantfile.read
    expect(contents).to match(/config.vm.box = "foo"$/)
    expect(contents).to match(/config.vm.box_url = "bar"$/)
  end

  it "outputs the Vagrantfile to another location if specified" do
    vagrantfile = environment.workdir.join("foo")

    assert_execute("vagrant", "init", "--output", "foo")
    expect(vagrantfile.exist?).to be(true)
    expect(vagrantfile.read).to match(/^Vagrant\.configure/)
  end

  it "outputs the Vagrantfile to stdout if specified" do
    result = execute("vagrant", "init", "--output", "-")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/^Vagrant\.configure/)
  end
end
