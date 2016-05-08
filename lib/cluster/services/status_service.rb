module RaspiFarm
  class Cluster::StatusService

    attr_reader :slaves, :arguments

    def initialize(scope, *arguments)
      @slaves = scope
    end

    def call
      ping_all_slaves
    end

    private

    def ping_all_slaves
      slaves.each do |slave|
        puts slave.alive? ? check_login(slave) : "#{slave.ip_address} is NOT alive"
      end
    end

    def check_login(slave)
      login_message = slave.can_login? ? 'login possible' : 'login NOT possible'
      "#{slave.ip_address} is alive, #{login_message}"
    end

    def self.help
    puts <<EOF

      TODO: help for status service
EOF
    end

  end
end
