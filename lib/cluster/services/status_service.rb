module RaspiFarm
  class Cluster::StatusService

    attr_reader :cluster

    def initialize(*arguments)
      @cluster = arguments[0]
    end

    def call
      puts "Status of configured nodes (see #{cluster.nodes_file_path})"
      ping_all_slaves
    end

    private

    def ping_all_slaves
      cluster.slaves.each do |slave|
        puts slave.alive? ? check_login(slave) : "#{slave.ip_address} is NOT alive"
      end
    end

    def check_login(slave)
      login_message = slave.can_login? ? 'login possible' : 'login NOT possible'
      "#{slave.ip_address} is alive, #{login_message}"
    end

  end
end
