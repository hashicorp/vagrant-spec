module Vagrant
  module Testlib
    # Tests the Vagrant version output
    OutputTester[:version] = lambda do |text, version|
      text =~ /^Vagrant version #{version}$/
    end
  end
end
