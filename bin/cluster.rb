require 'pathname'
base_path = Pathname.new(File.expand_path File.dirname(__FILE__)).parent

load '/home/farmer/cluster/lib/cluster.rb'
load '/home/farmer/cluster/lib/cluster/node.rb'
Dir.glob("/home/farmer/cluster/lib/**/*.rb").each { |file| require file }

nodes_config_path = base_path.join('etc', 'nodes.yml')

RaspiFarm::Cluster.new(nodes_config_path.to_s, *ARGV).call
