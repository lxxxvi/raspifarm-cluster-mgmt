module RaspiFarm
  class Cluster::Slave < Cluster::Node

    def initialize(ip_address)
      super(ip_address)
    end

    def execute(cmd)
      remote_execute(cmd)
    end

  end
end
