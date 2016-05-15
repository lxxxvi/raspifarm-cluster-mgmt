module RaspiFarm
  class Cluster::Node
    Result ||= Struct.new(:output, :success?)

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
      echo = "echo '' > /dev/null 2>&1"
      system(ssh_command(echo))
    end

    private
    def remote_execute(cmd, verbose = true)
      run(cmd, :system, verbose)
    end

    def remote_backticks(cmd, verbose = true)
      run(cmd, :backticks, verbose)
    end

    def run(cmd, method, verbose)
      puts "# Running '#{ssh_command(cmd)}'" if verbose
      return Result.new(nil, false) unless can_login?

      result = case method
               when :system
                 Result.new(nil, system(ssh_command(cmd)))
               when :backticks
                 output = `#{ssh_command(cmd)}`
                 Result.new(output, $?.exitstatus == 0)
               else
                 raise "Command method '#{method}' is unknown"
               end
    end

    def escape(cmd)
      cmd.gsub(/"/, "\\\"")
    end

    def ssh_command(cmd)
      "ssh farmer@#{ip_address} \"#{escape(cmd)}\""
    end

  end
end
