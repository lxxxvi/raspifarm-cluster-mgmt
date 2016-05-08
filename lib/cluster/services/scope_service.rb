module RaspiFarm
  class Cluster::ScopeService

    attr_reader :cluster, :targets, :scope

    def initialize(cluster, targets)
      @cluster = cluster
      load_targets(targets)
    end

    def each
      return enum_for(:each) unless block_given?
      scope.each { |slave| yield slave }
    end

    def help
      puts <<EOF
        ERROR: Invalid targets

        cluster <command> <targets>

        Please use 'all' or specific slave numbers delimited with ','   e.g.    15,16,17
EOF
    end

    def valid?
      scope
    end

    private

    def load_targets(targets)
      targets == 'all' ? handle_all : handle(targets)
    end

    def handle_all
      @scope = cluster.slaves
    end

    def handle(targets)
      return unless targets
      numbers = targets.split(',')
      @scope = cluster.slaves.find_all { |slave| numbers.include?(slave.number) }
    end

  end
end
