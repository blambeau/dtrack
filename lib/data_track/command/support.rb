module DataTrack
  class Command
    module Support
      extend Forwardable
      include Logging
      include Shell

      def_delegators :requester,
        :realm

    end # module Support
  end # class Command
end # module DataTrack
