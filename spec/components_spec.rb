require "fileutils"
require "pathname"
require "tmpdir"

require "vagrant-spec/components"

describe Vagrant::Spec::Components do
  let(:paths) { [Pathname.new(Dir.mktmpdir)] }

  subject { described_class.new(paths) }

  before do
    # Force instantiation
    subject
  end

  after do
    paths.each do |path|
      FileUtils.rmtree(path)
    end
  end

  describe "components" do
    it "should have no components to start" do
      expect(subject.components).to be_empty
    end

    it "can load the components" do
      paths[0].join("foo_spec.rb").open("w") do |f|
        f.write(<<-CONTENT)
describe "foo", component: "foo" do
end
        CONTENT
      end

      subject.reload!
      expect(subject.components).to eql(["foo"])
    end
  end

  describe "provider_features" do
    it "has none by default" do
      expect(subject.provider_features).to be_empty
    end

    it "loads features" do
      random = "#{Time.now.to_i}-#{Random.rand(1000)}"
      paths[0].join("shared_foo_spec.rb").open("w") do |f|
        f.write(<<-CONTENT)
shared_examples "#{random}" do
end

shared_examples "provider/#{random}-bar" do
end
        CONTENT
      end

      subject.reload!
      expect(subject.provider_features).to eql(["#{random}-bar"])
    end
  end
end
