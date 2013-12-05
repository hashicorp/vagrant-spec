require "vagrant-testlib/acceptance/shared/isolated_environment"

describe Vagrant::Testlib::AcceptanceIsolatedEnvironment do
  after do
    subject.close
  end

  describe "execute" do
    it "should execute the command return the output" do
      pending
    end
  end
end
