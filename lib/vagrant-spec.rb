require "pathname"

require "vagrant-spec/version"

module Vagrant
  module Spec
    # This returns the path to the root of the source tree for this library.
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
