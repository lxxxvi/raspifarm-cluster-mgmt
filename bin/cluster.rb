require 'pathname'
base_path = Pathname.new(File.expand_path File.dirname(__FILE__)).parent

Dir.glob('lib/*/**').each { |lib| load "#{base_path}/#{lib}"}

valid_commands = %w[list discover run ping help]

command = ARGV[0]

raise "Command #{command} is not known." if !valid_commands.include?(command)

case command
when 'list' then ClusterManager::NodeLister.new.call
when 'run'  then ClusterManager::NodeRunner.new(targets: ARGV[1], cmd: ARGV[2]).call
when 'ping' then ClusterManager::NodePinger.new.call
else
  puts <<EOF 

  raspi.farm cluster manager  

  Available commands

  cluster       list          not implemented yet (list available/configured nodes)
                run           run commands on all or specific nodes (partially implemented)
                discover      not implemented yet (discover Raspberry Pi noded in DHCP range)
                ping          ping all configured nodes
                help          display help

EOF
end
