require "vagrant-spec/subprocess"

describe Vagrant::Spec::Subprocess do
  it "should run and return output" do
    result = described_class.execute("echo", "foo")
    expect(result.stdout).to eql("foo\n")
    expect(result.exit_code).to eql(0)
  end
end
