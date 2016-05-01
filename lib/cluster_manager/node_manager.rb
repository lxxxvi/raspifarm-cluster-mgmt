require 'yaml'
require 'pathname'

module ClusterManager
  class NodeManager

    NODES_YML = 'nodes.yml'
    FIRST_NODE_NUMBER = 11

    def initialize
      base_dir = Pathname.new(File.expand_path File.dirname(__FILE__)).parent.parent
      @nodes_path = Pathname.new("#{base_dir}/etc/#{NODES_YML}")
      @nodes = YAML.load_file(nodes_path)['nodes']
    end

    def all_slaves_ip
      Array.new all_slaves('ip')
    end

    def all_slaves_mac
      Array.new all_slaves('mac')
    end

    def all_slaves(key)
      slaves.collect { |node, info| info[key] }
    end

    def find_slave_by_ip(ip_address)
      find_by('ip', ip_address)
    end

    def find_slave_by_mac(mac_address)
      find_by('mac', mac_address)
    end

    def find_slave_by_node_number(node_number)
      find_slave_by_ip("192.168.17.#{node_number}")
    end

    def find_slave_by(key, value)
      slaves.find { |node, info| info[key] == value }
    end

    def slaves
      return false unless nodes.any?
      nodes.find_all { |node, info| info['role'] == 'slave' }
    end

=begin
    def register_new_slave_node(mac_address, ip_address)
      return false if find_by_mac(mac_address)
      return false if find_by_ip(ip_address)

      new_node_name = create_node_name_by_ip(ip_address)
      new_node = { "#{new_node_name}" => { 'role' => 'slave', 'ip' => ip_address, 'mac' => mac_address } }
      save_node(new_node)
    end

    def create_node_name_by_ip(ip_address)
      number = ip_address[/([0-9]{2})?$/]
      "node-#{number}" if number.to_i > 9
    end

    def save_node(new_node)
      nodes.merge(new_node)
      output = YAML.dump(nodes)
      File.write(nodes_path.to_s, output)
    end
=end

    attr_reader :nodes, :nodes_path
  end
end
