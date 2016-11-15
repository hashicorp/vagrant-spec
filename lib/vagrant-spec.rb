require "pathname"

require "vagrant-spec/version"

module Vagrant
  module Spec
    # This returns the path to the directory of plugins that help with
    # acceptance tests.
    #
    # @return [Pathname]
    def self.acceptance_plugin_path
      source_root.join("acceptance", "support-plugins")
    end

    # This returns the path to the root of the source tree for this library.
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end

# Only load plugin interface if running within Vagrant context
if defined?(VagrantPlugins)
  require "vagrant-spec/vagrant-plugin/plugin"
end
