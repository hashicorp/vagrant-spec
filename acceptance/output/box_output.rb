require "vagrant-spec/acceptance/output"

module Vagrant
  module Spec
    # Tests that box add worked with details
    OutputTester[:box_added_detailed] = lambda do |text, name, version, provider|
      text =~ /Successfully added box '#{name}' \(v#{version}\) for '#{provider}'/
    end

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

    # Tests that box is outdated
    OutputTester[:box_outdated] = lambda do |text, name, provider, old_v, new_v|
      text =~ /'#{name}' for '#{provider}' is outdated! Current: #{old_v}\. Latest: #{new_v}/
    end

    # Tests that box is up to date
    OutputTester[:box_outdated_current] = lambda do |text, name|
      (text !~ /'#{name}' is outdated/) &&
        (text =~ /'#{name}'.+is up to date/)
    end
  end
end
