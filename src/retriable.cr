require "./retriable/*"
require "timeouter"

module Retriable
  extend self

  def retriable(opts)
    local_config = Config.new(config.to_h.merge(opts)

    tries = local_config.tries


    tries.times do |index|
      try = index + 1
      begin


      rescue exception
        interval = intervals[index]
        on_retry.call(exception, try, elapsed_time.call, interval) if on_retry
        raise if try >= tries || (elapsed_time.call + interval) > max_elapsed_time
        sleep interval if !sleep_disabled
      end
    end
  end
end
