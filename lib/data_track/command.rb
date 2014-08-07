require 'data_track'
#
# Data Track
#
# SYNOPSIS
#   dtrack [--version] [--help] COMMAND [cmd opts] ARGS...
#
# OPTIONS
# #{summarized_options}
#
# COMMANDS
# #{summarized_subcommands}
#
# See 'dtrack help COMMAND' for more information on a specific command.
#
module DataTrack
  class Command <  Quickl::Delegator(__FILE__, __LINE__)

    # Install options
    options do |opt|

      @realm_folder = Path.pwd
      opt.on('--realm=DIR', 'Set the realm directory') do |dir|
        @realm_folder = Path(dir)
        unless @realm_folder.exists?
          raise Quickl::IOAccessError, "No such folder: #{dir}"
        end
      end

      opt.on_tail('--help', "Show this help message"){ 
        raise Quickl::Help 
      }
      opt.on_tail('--version', 'Show version and exit'){
        raise Quickl::Exit, "dtrack #{VERSION}"
      }
    end

    def realm
      @realm ||= Realm.load(@realm_folder)
    end

  end # class Command
end # module DataTrack
require_relative 'command/support'
require_relative 'command/ping'
require_relative 'command/console'
require_relative 'command/schema'
require_relative 'command/dump'
require_relative 'command/restore'
require_relative 'command/instrument'
