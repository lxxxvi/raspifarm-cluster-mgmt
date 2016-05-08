module RaspiFarm
  class Cluster::RunnerService

    attr_reader :slaves, :command

    def initialize(scope=[], *arguments)
      @slaves = scope
      @command = arguments[0]
    end

    def call
      return Cluster::RunnerService.help unless command
      slaves.each { |on_slave| on_slave.execute(command) }
    end

    def self.help
      puts <<EOF

  Usage:
  cluster run TARGETS "COMMAND"

      TARGETS        'all' or specific node numbers (IP-addresses) delimited by ","    e.g.   13,14,16
      COMMAND       command to be executed, make sure it's enclosed by "              e.g.   "ifconfig | grep ip"

EOF
    end
  end
end
