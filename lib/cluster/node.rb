module RaspiFarm
  class Cluster::Node

    attr_reader :ip_address, :number

    def initialize(ip_address)
      @ip_address = ip_address
    end

    def number
      ip_address[/[0-9]*$/]
    end

    def alive?
      `ping -c 1 -t 1 #{ ip_address }`[/ 0% packet loss/]
    end

    def can_login?
      remote_execute("echo '' > /dev/null 2>&1")
    end

    private
    def remote_execute(cmd)
      cmd = "ssh farmer@#{ip_address} \"#{escape(cmd)}\""
      puts "# Running '#{cmd}'"
      system(cmd)
      puts "\n" * 2
    end

    def remote_backticks(cmd)
      `ssh farmer@#{ip_address} "#{escape(cmd)}"`
    end

    def escape(cmd)
      cmd.gsub(/"/, "\\\"")
    end

  end
end
