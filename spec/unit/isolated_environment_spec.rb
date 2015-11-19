require "fileutils"
require "pathname"
require "tmpdir"

require "vagrant-spec/unit/isolated_environment"

describe Vagrant::Spec::UnitIsolatedEnvironment do
  describe "#create_vagrant_env" do
    it "creates a vagrant environment" do
      env = subject.create_vagrant_env
      expect(env.cwd).to eq(subject.workdir)
    end
  end

  describe "#box" do
    skip
  end

  describe "#box2" do
    skip
  end

  describe "#box3" do
    skip
  end

  describe "#box1_file" do
    skip
  end

  describe "#box2_file" do
    skip
  end

  describe "#file" do
    it "creates a file in the working directory" do
      subject.file("foo", "bar")

      path = subject.workdir.join("foo")
      expect(path).to be_file
      expect(path.read).to eq("bar")
    end
  end

  describe "#vagrantfile" do
    it "creates a Vagrantfile" do
      subject.vagrantfile("foo")

      path = subject.workdir.join("Vagrantfile")
      expect(path).to be_file
      expect(path.read).to eq("foo")
    end

    it "creates a Vagrantfile in the specified directory" do
      dir = Pathname.new(Dir.mktmpdir)

      subject.vagrantfile("foo", dir)

      path = dir.join("Vagrantfile")
      expect(path).to be_file
      expect(path.read).to eq("foo")
    end
  end
end
