require "vagrant-spec/acceptance/configuration"

describe Vagrant::Spec::Acceptance::Configuration do
  describe "providers" do
    it "has no providers initially" do
      expect(subject.providers).to be_empty
    end

    it "can add providers" do
      subject.provider "foo", option: :bar

      p = subject.providers
      expect(p.length).to eql(1)
      expect(p["foo"]).to eql(option: :bar)
    end
  end
end
