require "vagrant-spec/isolated_environment"

describe Vagrant::Spec::IsolatedEnvironment do
  after do
    subject.close
  end

  it "should have a home dir" do
    expect(subject.homedir).to be_directory
    expect(subject.homedir.children).to be_empty
  end

  it "should have a work dir" do
    expect(subject.workdir).to be_directory
    expect(subject.workdir.children).to be_empty
  end

  context "after close" do
    before do
      subject.close
    end

    it "should not have a home dir" do
      expect(subject.homedir).to_not be_exist
    end

    it "should not have a work dir" do
      expect(subject.workdir).to_not be_exist
    end
  end
end
