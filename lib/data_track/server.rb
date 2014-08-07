module DataTrack
  class Server
    include Entity

    attr_accessor :realm

    def adapter
      @adapter ||= Adapter.send(handler, self)
    end

    def ping(&bl)
      adapter.admin_ping(&bl)
    end

    def console(*args, &bl)
      adapter.admin_console(*args, &bl)
    end

  end # class Server
end # module DataTrack
