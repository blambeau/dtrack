module DataTrack
  class Adapter
    include Entity

    def initialize(server)
      @server = server
    end
    attr_reader :server

    ############################################# Database information and uri

    def_delegators :server,
      :host, :port, :user, :password

    def database
      server.respond_to?(:database) ? server.database : nil
    end

    def admin
      server.admin || user
    end

    def admin_password
      server.admin ? server.admin_password : password
    end

    def uri
      uri = ""
      uri += "#{protocol}://#{user}"
      uri += ":#{password}" if password
      uri += "@#{host ||'localhost'}"
      uri += "/#{database}"
      uri
    end

    def admin_uri
      uri = ""
      uri += "#{protocol}://#{admin}"
      uri += ":#{admin_password}" if admin_password
      uri += "@#{host ||'localhost'}"
      uri += "/#{admin_database}"
      uri
    end

    ############################################################ User commands

    def sequel_db
      @sequel_db ||= ::Sequel.connect(uri)
    end

    def ping
      sequel_db.test_connection
      yield uri if block_given?
    rescue Sequel::DatabaseConnectionError => ex
      raise PingError.new(uri, ex)
    end

    ########################################################### Admin commands

    def admin_sequel_db
      @admin_sequel_db ||= ::Sequel.connect(admin_uri)
    end

    def admin_ping
      admin_sequel_db.test_connection
      yield admin_uri if block_given?
    rescue Sequel::DatabaseConnectionError => ex
      raise PingError.new(admin_uri, ex)
    end

    def create_view(name, defn)
      feedback "' Instrumenting #{name} event"
      sql_exec %Q{
        DROP VIEW IF EXISTS #{name};
        CREATE VIEW #{name} AS #{defn};
      }
    end

    def check
      error = nil
      dsource.events.each do |event|
        begin
          sequel_db[:"data_track_#{event.id}"].to_a
        rescue => ex
          puts "Event #{event.id} failed: #{ex.message}"
          error = ex
        end
      end
      raise error if error
    end

    def quote_identifier(id)
      sequel_db.quote_identifier(id)
    end

    def admin_exec(command)
      command = command.gsub(/^\s+/, '')
      info command
      admin_sequel_db.execute command
    end

    def sql_exec(command)
      sequel_db.execute info(sql_clean(command))
    end

    def sql_clean(sql)
      spaces = sql[/\A\n(\s*)/, 1].size
      sql.gsub(/^[ ]{#{spaces}}/, '').strip
    end

  end # class Adapter
end # module DataTrack
require_relative 'adapter/mysql'
require_relative 'adapter/pgsql'
