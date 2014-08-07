$:.unshift File.expand_path('../lib', __FILE__)
require 'path'

def shell(*cmds)
  puts(cmd = cmds.join("\n"))
  system cmd
end

Dir["tasks/*.rake"].each do |taskfile|
  load taskfile
end
task :default => :test