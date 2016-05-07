module RaspiFarm
  class Cluster::RunnerService

    def initialize(*arguments)
      @cluster, demanded_targets, @command = arguments.values_at(0, 1, 2)
      help unless targets_loaded(demanded_targets) && @command
    end

    def targets_loaded(demanded_targets)
      demanded_targets == 'all' ? handle_all : handle(demanded_targets)
      @target_slaves
    end

    def call
      return unless @target_slaves
      @target_slaves.each { |on_slave| on_slave.execute(@command) }
    end

    private

    attr_reader :cluster

    def handle_all
      @target_slaves = cluster.slaves
    end

    def handle(demanded_targets)
      numbers = demanded_targets.split(',')
      @target_slaves = cluster.slaves.find_all { |slave| numbers.include?(slave.number) }
    end

    def help
      puts <<EOF

  Cluster Runner Help

  Usage:
  cluster run TARGET "COMMAND"

      TARGET        'all' or specific node numbers (IP-addresses) delimited by ","    e.g.   13,14,16
      COMMAND       command to be executed, make sure it's enclosed by "              e.g.   "ifconfig | grep ip"

EOF
    end
  end
end
