require "vagrant-spec/acceptance/isolated_environment"

describe Vagrant::Spec::AcceptanceIsolatedEnvironment do
  after do
    subject.close
  end

  describe "execute" do
    it "should execute the command and return the result" do
      allow(Vagrant::Spec::Which).to receive(:which)
        .and_return("vagrant")

      result = Object.new
      allow(Vagrant::Spec::Subprocess).to receive(:execute) do |command, *args, **options|
        expect(command).to eql("vagrant")
        expect(args).to eql(["up"])

        expect(options[:env].key?("HOME")).to be(true)
        expect(options[:workdir]).to eql(subject.workdir.to_s)
      end.and_return(result)

      expect(subject.execute("vagrant", "up")).to eql(result)
    end

    it "should replace app paths" do
      allow(Vagrant::Spec::Which).to receive(:which)
        .and_return("/bin/foo")

      subject = described_class.new(apps: {
        "vagrant" => "/bin/foo",
      })

      result = Object.new
      allow(Vagrant::Spec::Subprocess).to receive(:execute) do |command, *args, **options|
        expect(command).to eql("/bin/foo")
        expect(args).to eql(["up"])

        expect(options[:env].key?("HOME")).to be(true)
        expect(options[:workdir]).to eql(subject.workdir.to_s)
      end.and_return(result)

      expect(subject.execute("vagrant", "up")).to eql(result)
    end
  end
end
