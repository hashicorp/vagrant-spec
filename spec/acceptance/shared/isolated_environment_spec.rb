require "vagrant-testlib/acceptance/isolated_environment"

describe Vagrant::Testlib::AcceptanceIsolatedEnvironment do
  after do
    subject.close
  end

  describe "execute" do
    it "should execute the command and return the result" do
      result = Object.new
      Vagrant::Testlib::Subprocess.
        should_receive(:execute).with do |command, *args, **options|
        expect(command).to eql("vagrant")
        expect(args).to eql(["up"])

        expect(options[:env].has_key?("HOME")).to be_true
        expect(options[:workdir]).to eql(subject.workdir.to_s)
      end.and_return(result)

      expect(subject.execute("vagrant", "up")).to eql(result)
    end

    it "should replace app paths" do
      subject = described_class.new(apps: {
        "vagrant" => "/bin/foo",
      })

      result = Object.new
      Vagrant::Testlib::Subprocess.
        should_receive(:execute).with do |command, *args, **options|
        expect(command).to eql("/bin/foo")
        expect(args).to eql(["up"])

        expect(options[:env].has_key?("HOME")).to be_true
        expect(options[:workdir]).to eql(subject.workdir.to_s)
      end.and_return(result)

      expect(subject.execute("vagrant", "up")).to eql(result)
    end
  end
end
