module RaspiFarm
  class Cluster::StatService

    attr_reader :slaves

    def initialize(scope, *arguments)
      return help if arguments[0] == 'help'
      @slaves = scope
    end

    def call
      slaves.each do |slave|
        puts "{ '#{slave.ip_address}': #{slave.stats} }"
      end
    end

    def self.help
      <<EOF
      TODO: statservice help
EOF
    end
  end
end
