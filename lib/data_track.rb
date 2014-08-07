require 'sequel'
require 'path'
require 'finitio'
require 'finitio/entity'
require 'forwardable'
require 'quickl'
require 'highline'

module DataTrack

  # Root folder
  ROOT = Path.dir.parent

  # Folder with data sources information
  DSOURCES_FOLDER = ROOT/'dsources'

  # Finition Schema for data validation
  FinitioSystem = Finitio::DEFAULT_SYSTEM.parse(Path.dir/"data_track/schema.fio")

  # Finitio module builder 
  FinitioEntity = Finitio.entity_builder(FinitioSystem)

  # Highline instance
  Highline = ::HighLine.new

end # module DataTrack
require_relative 'data_track/support/logging'
require_relative 'data_track/support/shell'
require_relative 'data_track/support/entity'
require_relative 'data_track/errors'
require_relative 'data_track/adapter'
require_relative 'data_track/server'
require_relative 'data_track/event'
require_relative 'data_track/deployment'
require_relative 'data_track/dsource'
require_relative 'data_track/realm'
