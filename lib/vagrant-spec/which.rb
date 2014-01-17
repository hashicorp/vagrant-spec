module Vagrant
  module Spec
    class Which
      # which is like the Unix `which` tool, it returns the full path
      # to an executable. This is especially important in Windows environments
      # where the suffix of a file (".exe", ".bat", etc.) must be given
      # to start child processes.
      def self.which(cmd)
        exts = nil

        if ENV['PATHEXT'].nil?
          # If the PATHEXT variable is empty, we're on *nix and need to find
          # the exact filename
          exts = ['']
        elsif File.extname(cmd).length != 0
          # On Windows: if filename contains an extension, we must match that
          # exact filename
          exts = ['']
        else
          # On Windows: otherwise try to match all possible executable file
          # extensions (.EXE .COM .BAT etc.)
          exts = ENV['PATHEXT'].split(';')
        end

        ENV['PATH'].encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').split(File::PATH_SEPARATOR).each do |path|
          exts.each do |ext|
            exe = "#{path}#{File::SEPARATOR}#{cmd}#{ext}"
            return exe if File.executable? exe
          end
        end

        return nil
      end
    end
  end
end
