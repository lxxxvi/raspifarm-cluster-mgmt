module ClusterManager
  class NodeRunner

    USER = 'farmer'

    def initialize(options = {})
      @node_manager = ClusterManager::NodeManager.new
      @targets, @cmd = options.values_at(:targets, :cmd)
      @target_ips = []
      validate_input
      prepare_target_ips
    end

    def call
      target_ips.each do |ip|
        puts "Running `#{cmd}` on #{ip}"
        system("ssh #{login_for(ip)} '#{cmd}'")
      end
    end

    private

    attr_reader :targets, :target_ips, :cmd, :node_manager

    def validate_input
      raise "No targets provided" if targets.nil?
      raise "Target list is invalid (#{targets})" if target_ips.include?(nil)
    end

    def prepare_target_ips
      @target_ips = (targets == 'all') ? node_manager.all_slaves_ip : custom_targets
    end

    def custom_targets
      targets.split(',').collect { |t| node_manager.find_slave_by_node_number(t) }
    end

    def login_for(ip)
      @login = "#{USER}@#{ip}"
    end
  end
end
