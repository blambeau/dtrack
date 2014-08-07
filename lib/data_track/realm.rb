module DataTrack
  class Realm
    include Entity

    None = Object.new

    def initialize(*args, &bl)
      super
      each_server{|s| s.realm = self }
      each_datasource{|s| s.realm = self }
    end

    def self.load(folder)
      servers = (folder/'servers.yml').load
      datasources = folder.glob('**/*.info.yml').map(&:load)
      dress({
        root:        folder,
        servers:     servers,
        datasources: datasources
      })
    end

    def each_server(&bl)
      servers.each(&bl)
    end

    def server_by_name(name, default = None)
      srv = servers.find{|s| s.server == name }
      if srv.nil? and default==None
        raise NoSuchServerError.new(self, name)
      else
        srv || default
      end
    end

    def each_datasource(&bl)
      datasources.each(&bl)
    end

    def datasource_by_name(name, default = None)
      ds = datasources.find{|d| d.dsource == name }
      if ds.nil? and default==None
        raise NoSuchDatasourceError.new(self, name)
      else
        ds || default
      end
    end

  end # class Realm
end # module DataTrack
