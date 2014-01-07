require "vagrant-spec/acceptance/output"

module Vagrant
  module Spec
    # Tests the Vagrant plugin list output has no plugins
    OutputTester[:plugin_list_none] = lambda do |text|
      text =~ /^No plugins/
    end

    # Tests that plugin list shows a plugin
    OutputTester[:plugin_list_plugin] = lambda do |text, name, version|
      text =~ /^#{name} \(#{version}\)$/
    end

    # Tests that Vagrant plugin install fails to a plugin not found
    OutputTester[:plugin_install_not_found] = lambda do |text, name|
      text =~ /^The plugin '#{name}' could not be/
    end

    # Tests that Vagrant plugin install fails to a plugin not found
    OutputTester[:plugin_installed] = lambda do |text, name, version|
      text =~ /^Installed the plugin '#{name} \(#{version}\)'/
    end
  end
end
