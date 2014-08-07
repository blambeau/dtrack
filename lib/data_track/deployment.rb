module DataTrack
  class Deployment
    include Entity

    alias :id :deployment

    attr_accessor :data_source

    def realm
      data_source.realm
    end

    def handler
      super || _server.handler
    end

    def host
      super || _server.host
    end

    def port
      super || _server.port
    end

    def user
      super || _server.user
    end

    def password
      super || _server.password
    end

    def adapter
      @adapter ||= Adapter.send(handler, self)
    end

    def_delegators :adapter,
      :ping,
      :console,
      :restore_file,
      :dump_to

    def dump_schema
      shell("java", {
        jar:  ROOT/"vendor/schemaSpy_5.0.0.jar",
        dp:   ROOT/"vendor/#{adapter.spy_jar}",
        t:    adapter.spy_handler,
        host: host,
        u:    user,
        p:    password,
        db:   database,
        o:    data_source.schema_folder
      }.merge(adapter.spy_options))
    end

    def dump
      dump_folder = data_source.dump_folder
      raise NoSuchDumpError, dump_folder.to_s unless dump_folder.exists?
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      dump_file = dump_folder/"#{data_source.id}-#{id}-#{timestamp}.sql"
      dump_to(dump_file)
    end

    def restore(timestamp = nil)
      dump_folder = data_source.dump_folder
      pattern = timestamp ? "*-#{timestamp}*" : "*"
      raise NoSuchDumpError, dump_folder/pattern unless dump_folder.exists?
      dump_file = dump_folder.glob(pattern).last
      raise NoSuchDumpError, dump_folder/pattern unless dump_file
      restore_file(dump_file)
    end

    def instrument
      data_source.events.each do |event|
        adapter.create_view("dt_#{event.id}", event.formaldef)
      end
    end

  private

    def _server
      realm.server_by_name(server)
    end

  end # class Deployment
end # module DataTrack
