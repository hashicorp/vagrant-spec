# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

require "vagrant-spec/acceptance/output"

describe Vagrant::Spec::OutputTester do
  subject { described_class }

  let(:registry) { described_class }

  it "raises an exception if the matcher doesn't exist" do
    expect { subject.matches?("foo", :i_dont_exist) }.
      to raise_error(ArgumentError)
  end

  context "with a basic matcher" do
    before do
      registry[:test] = lambda do |text|
        text == "foo"
      end
    end

    after do
      registry.delete(:test)
    end

    it "should match with good input" do
      expect(described_class.matches?("foo", :test)).to be_truthy
    end

    it "should not match with bad output" do
      expect(described_class.matches?("bar", :test)).to_not be_truthy
    end
  end

  context "with a matcher with args" do
    before do
      registry[:test] = lambda do |text, compare|
        text == compare
      end
    end

    after do
      registry.delete(:test)
    end

    it "should match with good input" do
      expect(described_class.matches?("foo", :test, "foo")).to be_truthy
      expect(described_class.matches?("bar", :test, "bar")).to be_truthy
    end

    it "should not match with bad output" do
      expect(described_class.matches?("bar", :test, "foo")).to_not be_truthy
    end
  end
end
