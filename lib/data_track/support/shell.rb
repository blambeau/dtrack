module DataTrack
  module Shell
    include Logging

    def shell(command, options = nil, args = nil)
      cmd = command.dup

      # Encode options
      options.each_pair do |k,v|
        next unless v
        cmd << " -" << k.to_s
        cmd << " "  << v.to_s unless v==true
      end if options

      # Encore arguments
      args.each do |arg|
        cmd << " " << arg.to_s
      end if args

      # Let's go
      system(feedback(cmd))
    end

  end # module Shell
end # module DataTrack
