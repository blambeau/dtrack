module DataTrack
  class Adapter
    class Mysql < self

      def protocol
        "mysql"
      end

      def admin_database
        "information_schema"
      end

      def spy_jar
        "com.mysql.jdbc_5.1.5.jar"
      end

      def spy_handler
        "mysql"
      end

      def spy_options
        {}
      end

      def dropuser
        admin_exec %Q{
          DROP USER '#{user}'@'#{host}';
        }        
      end

      def createuser
        admin_exec %Q{
          CREATE USER '#{user}'@'#{host}';
        }        
      end

      def dropdb
        admin_exec %Q{
          DROP DATABASE IF EXISTS #{database};
        }
      end

      def createdb
        admin_exec %Q{
          DROP DATABASE IF EXISTS #{database};
          CREATE DATABASE #{database};
          GRANT ALL PRIVILEGES ON #{database}.* TO '#{user}'@'#{host}' IDENTIFIED BY '#{password}';
        }
      end

      def dump_to(file)
        shell "mysqldump", command_line_options({
          r: file,
          D: nil  # no -D on mysqldump unlike mysql
        }), [ database ]
      end

      def restore_file(file)
        shell "mysql", command_line_options({
        }), [ "<", file ]
      end

      def console
        shell "mysql", command_line_options
      end

      def admin_console
        shell "mysql", command_line_options({
          D: admin_database,
          u: admin,
          p: !!admin_password
        })
      end

      def command_line_options(overriding = {})
        {
          D: database,
          h: host,
          P: port,
          u: user,
          p: !!password
        }.merge(overriding)
      end

    end # class Mysql

    def self.mysql(dsource)
      Mysql.new(dsource)
    end

  end # class Adapter
end # module DataTrack
