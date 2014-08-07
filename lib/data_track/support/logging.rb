module DataTrack
  module Logging

    def ok(msg)
      Highline.say Highline.color(msg, :green)
      msg
    end

    def feedback(msg)
      Highline.say Highline.color(msg, :bright_blue)
      msg
    end

    def error(msg)
      Highline.say Highline.color(msg, :red)
      msg
    end

    def info(msg)
      Highline.say msg
      msg
    end

  end # module Logging
end # module DataTrack