require 'yaml'

module RaspiFarm
  class Cluster

    attr_reader :nodes_file_path, :arguments

    def initialize(nodes_file_path, *arguments)
      @nodes_file_path = nodes_file_path
      @arguments = { service: arguments.shift, scope: arguments.shift, service_arguments: arguments}
      load_nodes
    end

    def call
      return help unless respond_to?(arguments[:service].to_sym)
      execute(send(arguments[:service].to_sym))
    end

    def master
      @master_node ||= @all_nodes.
                    find { |name, node| node['role'] == 'master' }.
                    map{ |name, node| RaspiFarm::Cluster::Master.new(node['ip'])}
    end

    def slaves
      @slave_nodes ||= @all_nodes.
                    find_all { |name, node| node['role'] == 'slave' && node['enabled'] === true }.
                    map { |name, node| RaspiFarm::Cluster::Slave.new(node['ip']) }
    end

    def status
      Cluster::StatusService
    end

    def run
      Cluster::RunnerService
    end

    def stats
      Cluster::StatService
    end

    private

    def execute(service)
      return service.help if arguments[:scope] == 'help'
      scope = Cluster::ScopeService.new(self, arguments[:scope])
      return scope.help unless scope.valid?
      service.new(scope, *arguments[:service_arguments]).call
    end

    def load_nodes
      @all_nodes = ::YAML.load_file(nodes_file_path)['nodes']
    end

    def help
      puts "  ERROR: command or service '#{ arguments[:service] }' is not known" unless arguments[:service] == 'help'

      puts <<EOF

      raspi.farm cluster manager

      Available services

      cluster help          display this help
              run           run commands on enabled slaves
              stats         display statistics of configured nodes
              status        display status of configured nodes

EOF
    end

  end
end
