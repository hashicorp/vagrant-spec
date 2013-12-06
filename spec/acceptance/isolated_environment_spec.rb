require "fileutils"
require "pathname"
require "tmpdir"

require "vagrant-spec/acceptance/isolated_environment"

describe Vagrant::Spec::AcceptanceIsolatedEnvironment do
  let(:skeleton_path) { Pathname.new(Dir.mktmpdir) }

  subject do
    described_class.new(
      skeleton_paths: [skeleton_path]
    )
  end

  after do
    FileUtils.rmtree(skeleton_path)
  end

  describe "skeleton" do
    it "raises an exception if the skeleton doesn't exist" do
      expect { subject.skeleton("foo") }.
        to raise_error(ArgumentError)
    end

    it "copies the skeleton directory" do
      path = skeleton_path.join("foo")
      path.mkpath
      path.join("bar").mkpath
      path.join("bar", "baz").open("w") { |f| f.write("baz") }
      path.join("foo").open("w") { |f| f.write("hello") }

      subject.skeleton("foo")

      d = subject.workdir
      expect(d.join("bar")).to be_directory
      expect(d.join("bar", "baz")).to be_file
      expect(d.join("bar", "baz").read).to eql("baz")
      expect(d.join("foo")).to be_file
      expect(d.join("foo").read).to eql("hello")
    end
  end
end
