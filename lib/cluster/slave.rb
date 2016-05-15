module RaspiFarm
  class Cluster::Slave < Cluster::Node

    attr_reader :cpu, :memory

    def initialize(ip_address)
      super(ip_address)
    end

    def execute(cmd)
      remote_execute(cmd)
    end

    def stats
      cpu_cmd = "top -bn2 -d 0.2 | grep '^%Cpu' | tail -1"
      mem_cmd = "top -bn1 | grep '^KiB Mem'"
      result = remote_backticks([cpu_cmd, mem_cmd].join(';'), false)

      if result.success?
        analyze(result.output)
        to_json
      end
    end

    def to_json
      " { 'cpu': #{cpu}, 'memory': #{memory} } "
    end

    private

    def analyze(string)
      @cpu = calculate_cpu_usage(string[/%Cpu.*/])
      @memory = calculate_memory_usage(string[/KiB.*/])
    end

    def calculate_cpu_usage(string)
      # Example string:  "%Cpu(s): 16.7 us,  0.0 sy,  0.0 ni, 83.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st"
      #                                                       -[7]-
      (100.0 - string.split(' ')[7].to_f).round(2)
    end

    def calculate_memory_usage(string)
      # Example string:  "KiB Mem:    948012 total,   201836 used,   746176 free,    24420 buffers"
      #                               ------          ------
      total, used = string.scan(/[0-9]+/).values_at(0..1)
      ((used.to_f / total.to_f) * 100).round(2)
    end

  end
end
