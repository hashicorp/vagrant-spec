module VSHB
  class Command < Vagrant.plugin("2", "command")
    def execute
      puts "I HAVE BEEN EXECUTED"
    end
  end
end
