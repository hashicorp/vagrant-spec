require "vagrant-spec/acceptance/output"

module Vagrant
  module Spec
    # Tests that box list has no boxes.
    OutputTester[:box_list_no_boxes] = lambda do |text|
      text =~ /There are no installed boxes/
    end

    # Tests that box list has a certain box
    OutputTester[:box_list_box] = lambda do |text, name|
      text =~ /^#{name}\s+/
    end
  end
end
