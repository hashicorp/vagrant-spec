require "vagrant-spec/acceptance/output"

module Vagrant
  module Spec
    # Default plugins within plugin list when run mode
    # is set as "plugin"
    DEFAULT_PLUGINS = ["vagrant-share".freeze].freeze

    # Tests the Vagrant plugin list output has no plugins
    OutputTester[:plugin_list_none] = lambda do |text|
      text =~ /^No plugins/
    end

    # Tests that plugin list shows a plugin
    OutputTester[:plugin_list_plugin] = lambda do |text, name, version|
      text =~ /^#{name} \(#{version}, global\)$/
    end

    # Tests that Vagrant plugin install fails to a plugin not found
    OutputTester[:plugin_install_not_found] = lambda do |text, name|
      text =~ /Unable to resolve dependency:.* '#{name}/
    end

    # Tests that Vagrant plugin install fails to a plugin not found
    OutputTester[:plugin_installed] = lambda do |text, name, version|
      if version.nil?
        text =~ /^Installed the plugin '#{name} \(/
      else
        text =~ /^Installed the plugin '#{name} \(#{version}\)'/
      end
    end

  end
end
