module DataTrack
  class Command
    #
    # Open a native database console on a server or datasource
    #
    # SYNOPSIS
    #   #{command_name} [options] [SERVER|DATA_SOURCE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Console < Quickl::Command(__FILE__, __LINE__)
      include Support

      # Install options
      options do |opt|
      end
  
      # Run the command
      def execute(args)
        raise Quickl::InvalidArgument unless args.size == 1
        console(args.first)
      end

    private

      def console(which)
        target   = realm.server_by_name(which, nil)
        target ||= realm.datasource_by_name(which, nil)
        if target
          target.console
        else
          raise NoSuchError.new(realm, which)
        end
      end

    end # class Console
  end # class Command
end # module DataTrack
