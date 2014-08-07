module DataTrack
  class Command
    #
    # Dump a database backup
    #
    # SYNOPSIS
    #   #{command_name} [options] DATA_SOURCE
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Dump < Quickl::Command(__FILE__, __LINE__)
      include Support

      # Install options
      options do |opt|
        @all = false
        opt.on('-a', '--all', "Apply on each datasource in turn") do
          @all = true
        end
      end
  
      # Run the command
      def execute(args)
        raise Quickl::InvalidArgument unless @all and args.empty? or args.size == 1
        if args.empty?
          dump_all
        else
          dump(*args)
        end
      end

    private

      def dump_all
        realm.each_datasource do |ds|
          ds.dump
        end
      end

      def dump(which)
        ds = realm.datasource_by_name(which)
        ds.dump
      end

    end # class Dump
  end # class Command
end # module DataTrack
