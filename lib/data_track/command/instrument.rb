module DataTrack
  class Command
    #
    # Instrument a datasource with event views
    #
    # SYNOPSIS
    #   #{command_name} [options] [DATA_SOURCE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Instrument < Quickl::Command(__FILE__, __LINE__)
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
          instrument_all
        else
          instrument(*args)
        end
      end

    private

      def instrument_all
        realm.each_datasource do |ds|
          ds.instrument
        end
      end

      def instrument(which)
        ds = realm.datasource_by_name(which)
        ds.instrument
      end

    end # class Instrument
  end # class Command
end # module DataTrack
