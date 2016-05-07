require 'yaml'

module RaspiFarm
  class Cluster

    attr_reader :nodes_file_path

    def initialize(nodes_file_path)
      @nodes_file_path = nodes_file_path
      load_nodes
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
      Cluster::StatusService.new(self).call
    end

    def run(arguments)
      Cluster::RunnerService.new(self, *arguments).call
    end

    private

    def load_nodes
      @all_nodes = ::YAML.load_file(nodes_file_path)['nodes']
    end

  end
end
