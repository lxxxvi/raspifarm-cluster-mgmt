require 'pathname'
base_path = Pathname.new(File.expand_path File.dirname(__FILE__)).parent

Dir.glob('lib/**').each { |lib| load "#{base_path}/#{lib}"}

valid_commands = %w[list discover run help]

command = ARGV[0]

raise "Command #{command} is not known." if !valid_commands.include?(command)

case command
when 'list' then ClusterManager::NodeLister.new.call
when 'run'  then ClusterManager::NodeRunner.new(targets: ARGV[1], cmd: ARGV[2]).call
end


=begin

  commands:

  list            list known nodes
  discover        discover known nodes
  run             run commands on nodes

=end
