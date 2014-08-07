module DataTrack
  class Command
    #
    # Ping a server or a datasource to check if it is alive
    #
    # SYNOPSIS
    #   #{command_name} [options] [SERVER|DATA_SOURCE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    class Ping < Quickl::Command(__FILE__, __LINE__)
      include Support

      # Install options
      options do |opt|
      end
  
      # Run the command
      def execute(args)
        raise Quickl::InvalidArgument unless args.size <= 1
        if which = args.first
          ping(which)
        else
          ping_all
        end
      end

    private

      def ping(which)
        if server = realm.server_by_name(which, nil)
          ping_server(server)
        elsif ds = realm.datasource_by_name(which, nil)
          ping_datasource(ds)
        else
          raise NoSuchError.new(realm, which)
        end
      end

      def ping_all
        realm.each_server do |server|
          ping_server(server)
        end
        realm.each_datasource do |ds|
          ping_datasource(ds)
        end
      end

      def ping_server(server)
        server.ping do |uri|
          ok "Server ping ok: #{uri}"
        end
      rescue PingError => ex
        ex.react!
      end

      def ping_datasource(ds)
        ds.ping do |uri|
          ok "Datasource ping ok: #{uri}"
        end
      rescue PingError => ex
        ex.react!
      end

    end # class Ping
  end # class Command
end # module DataTrack
