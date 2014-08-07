module DataTrack

  class Error < Quickl::Error
    include Logging

    def initialize(realm, *args)
      super(*args)
      @realm = realm
    end
    attr_reader :realm

  end # class Error

  class NoSuchServerError < Error

    def react!
      servers = realm.servers.map(&:server)
      error "No such server: `#{message}`"
      info "Servers are: #{servers.join(', ')}"
    end

  end # class NoSuchError

  class NoSuchDatasourceError < Error

    def react!
      datasources = realm.datasources.map(&:dsource)
      error "No such data source: `#{message}`"
      info "Data sources are: #{datasources.join(', ')}"
    end

  end # class NoSuchDatasourceError

  class NoSuchError < Error

    def react!
      servers = realm.servers.map(&:server)
      datasources = realm.datasources.map(&:dsource)
      error "No such server or datasource: `#{message}`"
      info "Servers are: #{servers.join(', ')}"
      info "Data sources are: #{datasources.join(', ')}"
    end

  end # class NoSuchError

  class PingError < Error

    def initialize(uri, cause)
      @uri = uri
      @cause = cause
    end

    def message
      "Ping failed on: #{@uri}"
    end

    def react!
      error message
      info @cause.message
    end

  end # class PingError

  class NoDeploymentError < Error

    def initialize(ds)
      @ds = ds
    end

    def message
      "No deployment on #{@ds}"
    end

    def react!
      error message
    end

  end # class NoDeploymentError

  class NoSuchDumpError < Error

    def initialize(dump)
      @dump = dump
    end

    def message
      "No such dump `#{@dump}`"
    end

    def react!
      error message
    end

  end # class NoSuchDumpError

end # module DataTrack
