module DataTrack
  module Entity
    include Shell
    include Logging

    def self.included(by)
      name = by.name.to_s[/::(.*?)$/, 1]
      if FinitioSystem[name]
        by.instance_eval{
          include(FinitioEntity)
        }
      end
      by.extend(Forwardable)
    end

  end # module Entity
end # module DataTrack
