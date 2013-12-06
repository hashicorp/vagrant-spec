require "fileutils"
require "pathname"
require "tmpdir"

require "vagrant-spec/components"

describe Vagrant::Spec::Components do
  let(:world) { RSpec::Core::World.new }
  let(:paths) { [Pathname.new(Dir.mktmpdir)] }

  subject { described_class.new(world, paths) }

  after do
    paths.each do |path|
      FileUtils.rmtree(path)
    end
  end

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
