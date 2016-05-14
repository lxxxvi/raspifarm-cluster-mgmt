module RaspiFarm
  class Cluster::InstallerService

    attr_reader :slaves, :packages

    def initialize(scope, *arguments)
      return help if arguments[0] == 'help'
      @slaves = scope
      @packages = arguments[0]
    end

    def call
      return Cluster::InstallerService.help unless packages_valid?
      slaves.each { |on_slave| on_slave.execute(command) }
    end

    def self.help
      puts <<EOF
      TODO
EOF
    end

    private
    def command
      "sudo apt-get update && sudo apt-get -y install #{packages}"
    end

    def packages_valid?
      packages && !packages.empty?
    end

  end
end
