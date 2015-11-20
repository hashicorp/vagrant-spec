require "tempfile"
require "thread"
require "webrick"

module Vagrant
  module Spec
    module Server
      # Starts a temporary web server that serves a document root.
      # This knows how to serve proper mime types for JSON so it can
      # be used for box metadata and such.
      #
      # @param [String] path The document root
      def with_web_server(path, **opts)
        tf = Tempfile.new("vagrant")
        tf.close

        opts[:json_type] ||= "application/json"

        mime_types = WEBrick::HTTPUtils::DefaultMimeTypes
        mime_types.store "json", opts[:json_type]

        port   = opts[:port] || 3838
        server = WEBrick::HTTPServer.new(
          AccessLog: [],
          Logger: WEBrick::Log.new(tf.path, 7),
          Port: port,
          DocumentRoot: path.dirname.to_s,
          MimeTypes: mime_types)
        thr = Thread.new { server.start }
        yield port
      ensure
        server.shutdown rescue nil
        thr.join rescue nil
      end
    end
  end
end
