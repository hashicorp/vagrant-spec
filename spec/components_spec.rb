require "vagrant-spec/components"

describe Vagrant::Spec::Components do
  before do
    @old_world = RSpec.world
    RSpec.world = RSpec::Core::World.new
  end

  after do
    RSpec.world = @old_world
  end

  describe "load_default!" do
    it "knows about the default components" do
      described_class.load_default!

      c = described_class.components
      expect(c).to_not be_empty
      expect(c.include?("cli")).to be_true
    end
  end

  describe "load_from!" do
    it "loads components" do
      described_class.load_from!(Vagrant::Spec.source_root.join("acceptance"))

      c = described_class.components
      expect(c).to_not be_empty
      expect(c.include?("cli")).to be_true
    end
  end
end
