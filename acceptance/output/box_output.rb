require "vagrant-spec/acceptance/output"

module Vagrant
  module Spec
    # Tests that box add failed with a bad provider
    OutputTester[:box_add_wrong_provider] = lambda do |text|
      text =~ /doesn't match the provider/
    end

    # Tests that box list has a certain box
    OutputTester[:box_list_added] = lambda do |text, name|
      text =~ /Successfully added box '#{name}'/
    end

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
