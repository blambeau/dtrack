module DataTrack
  class Dsource
    include Entity

    def initialize(*args, &bl)
      super
      @events ||= []
      @deployments ||= []
    end
    alias :id :dsource

    attr_reader :realm
    def realm=(realm)
      @realm = realm
      deployments.each do |dep|
        dep.data_source = self
      end
    end

    def schema_folder
      realm.root/id/'schema'
    end

    def dump_folder
      realm.root/id/'dump'
    end

    def ping(&bl)
      deployments.each do |dep|
        dep.ping(&bl)
      end
    end

    def main_deployment
      raise NoDeploymentError, id if deployments.empty?
      deployments.first
    end

    def_delegators :main_deployment,
      :console,
      :dump_schema,
      :deployment,
      :restore,
      :dump,
      :instrument

  end # class Dsource
end # module DataTrack
