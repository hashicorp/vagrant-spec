require "vagrant-spec/acceptance/output"

module Vagrant
  module Spec
    # Default plugins within plugin list when run mode
    # is set as "plugin"
    DEFAULT_PLUGINS = ["vagrant-share".freeze].freeze

    # Tests the Vagrant plugin list output has no plugins
    OutputTester[:plugin_list_none] = lambda do |text|
      if Vagrant::Spec::Acceptance.config.run_mode == "plugin"
        valid = DEFAULT_PLUGINS.all? do |plugin_name|
          text.include?(plugin_name)
        end
        if valid
          valid = !text.lines.any? do |line|
            !line.start_with?(" ") &&
              !DEFAULT_PLUGINS.include?(line.split(/\s/).first)
          end
        end
        valid
      else
        text =~ /^No plugins/
      end
    end

    # Tests that plugin list shows a plugin
    OutputTester[:plugin_list_plugin] = lambda do |text, name, version|
      text =~ /^#{name} \(#{version}\)$/
    end

    # Tests that Vagrant plugin install fails to a plugin not found
    OutputTester[:plugin_install_not_found] = lambda do |text, name|
      text =~ /Unable to resolve dependency:.* '#{name}/
    end

    # Tests that Vagrant plugin install fails to a plugin not found
    OutputTester[:plugin_installed] = lambda do |text, name, version|
      text =~ /^Installed the plugin '#{name} \(#{version}\)'/
    end
  end
end
