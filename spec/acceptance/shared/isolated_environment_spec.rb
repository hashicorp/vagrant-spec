require "vagrant-spec/acceptance/isolated_environment"

describe Vagrant::Spec::AcceptanceIsolatedEnvironment do
  after do
    subject.close
  end

  describe "execute" do
    it "should execute the command and return the result" do
      expect(Vagrant::Spec::Which).to receive(:which).and_return("vagrant")

      result = Object.new
      expect(Vagrant::Spec::Subprocess).to receive(:execute) do |command, *args, **options|
        expect(command).to eql("vagrant")
        expect(args).to eql(["up"])

        expect(options[:env].has_key?("HOME")).to be_truthy
        expect(options[:workdir]).to eql(subject.workdir.to_s)
      end.and_return(result)

      expect(subject.execute("vagrant", "up")).to eql(result)
    end

    it "should replace app paths" do
      expect(Vagrant::Spec::Which).to receive(:which).and_return("/bin/foo")

      subject = described_class.new(apps: {
        "vagrant" => "/bin/foo",
      })

      result = Object.new
      expect(Vagrant::Spec::Subprocess).to receive(:execute) do |command, *args, **options|
        expect(command).to eql("/bin/foo")
        expect(args).to eql(["up"])

        expect(options[:env].has_key?("HOME")).to be_truthy
        expect(options[:workdir]).to eql(subject.workdir.to_s)
      end.and_return(result)

      expect(subject.execute("vagrant", "up")).to eql(result)
    end

    it "should accept additional extra_env" do
      expect(Vagrant::Spec::Which).to receive(:which).and_return("vagrant")

      result = Object.new
      expect(Vagrant::Spec::Subprocess).to receive(:execute) do |command, *args, **options|
        expect(options[:env].has_key?("HOME")).to be_truthy
        expect(options[:env].has_key?(:CUSTOM_VAR)).to be_truthy
      end.and_return(result)

      expect(subject.execute("vagrant", "up", :extra_env => {"CUSTOM_VAR": "CUSTOM_VALUE"})).to eql(result)
    end
  end
end
