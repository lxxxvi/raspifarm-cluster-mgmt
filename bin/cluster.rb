require 'pathname'
base_path = Pathname.new(File.expand_path File.dirname(__FILE__)).parent

load '/home/farmer/cluster/lib/cluster.rb'
load '/home/farmer/cluster/lib/cluster/node.rb'
Dir.glob("/home/farmer/cluster/lib/**/*.rb").each { |file| require file }

nodes_config_path = base_path.join('etc', 'nodes.yml')

cluster = RaspiFarm::Cluster.new(nodes_config_path.to_s)

command = ARGV.shift

case command
#when 'list'   then ClusterManager::NodeLister.new.call
#when 'run'    then ClusterManager::NodeRunner.new(targets: ARGV[1], cmd: ARGV[2]).call
when 'status' then cluster.status
when 'run'    then cluster.run(ARGV)
else

  puts "  ERROR: command '#{command}' is not known" unless command == 'help'

  puts <<EOF

  raspi.farm cluster manager

  Available commands

  cluster         help          display help
                  run           run commands on enabled slaves
                  status        display status of configured nodes

EOF
end
