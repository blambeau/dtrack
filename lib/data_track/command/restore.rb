module DataTrack
  class Command
    #
    # Restore the last backup
    #
    # SYNOPSIS
    #   #{command_name} [options] DATA_SOURCE [TIMESTAMP]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Restore < Quickl::Command(__FILE__, __LINE__)
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
        if @all
          raise Quickl::InvalidArgument unless args.size <= 1
          restore_all(*args)
        else
          raise Quickl::InvalidArgument unless (1..2).include?(args.size)
          restore(*args)
        end
      end

    private

      def restore_all(timestamp = nil)
        realm.each_datasource do |ds|
          ds.restore(timestamp)
        end
      end

      def restore(which, timestamp = nil)
        ds = realm.datasource_by_name(which)
        ds.restore(timestamp)
      end

    end # class Restore
  end # class Command
end # module DataTrack
