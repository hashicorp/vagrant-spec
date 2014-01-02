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
      expect(p["foo"][:option]).to eql(:bar)
    end

    it "adds a features array to providers by default" do
      subject.provider "foo"

      p = subject.providers
      expect(p.length).to eql(1)
      expect(p["foo"]).to eql(features: [])
    end
  end
end
