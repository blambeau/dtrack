module DataTrack
  class Adapter
    class Pgsql < self

      def protocol
        "postgres"
      end

      def admin_database
        "template1"
      end

      def spy_jar
        "postgresql-9.2-1003.jdbc4.jar"
      end

      def spy_handler
        "pgsql"
      end

      def spy_options
        { s: "public" }
      end

      def createuser
        shell("createuser #{user}")
      end

      def dropuser
        shell("dropuser #{user}")
      end

      def createdb
        shell("createdb --owner #{user} #{database}")
      end

      def dropdb
        shell("dropdb --if-exists #{database}")
      end

      def dump_to(file)
        shell "pg_dump", command_line_options({
          f: file,
          c: true,  # --clean
        })
      end

      def restore_file(file)
        shell "psql", command_line_options({
          f: file,
        })
      end

      def console
        shell "psql", command_line_options
      end

      def admin_console
        shell "psql", command_line_options({
          d: admin_database,
          U: admin,
          W: !!admin_password
        })
      end

      def command_line_options(overriding = {})
        {
          d: database,
          h: host,
          p: port,
          U: user,
          W: password
        }.merge(overriding)
      end

    end # class Pgsql

    def self.pgsql(dsource)
      Pgsql.new(dsource)
    end

  end # class Adapter
end # module DataTrack
