module DataTrack
  class Command
    #
    # Opens the schema of a data source.
    #
    # SYNOPSIS
    #   #{command_name} [options] [SERVER|DATA_SOURCE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Schema < Quickl::Command(__FILE__, __LINE__)
      include Support

      # Install options
      options do |opt|
        @force = false
        opt.on('-f', '--force') do
          @force = true
        end
      end
  
      # Run the command
      def execute(args)
        raise Quickl::InvalidArgument unless args.size == 1
        schema(args.first)
      end

    private

      def schema(which)
        ds = realm.datasource_by_name(which)
        if @force || !ds.schema_folder.exists?
          ds.dump_schema
        end
        shell("open #{ds.schema_folder}/index.html")
      end

    end # class Schema
  end # class Command
end # module DataTrack
