module ClusterManager
    class NodePinger

        attr_reader :node_manager

        def initialize
            @node_manager = ClusterManager::NodeManager.new
        end


        def call
            node_manager.slaves.each do |name, node|
                result = `ping -c 1 #{ node['ip'] }`[/ 0% packet loss/] ? "alive" : "NOT alive"
                puts "#{ node['ip'] } is #{result}"
            end
        end

    end
end