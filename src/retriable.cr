require "./retriable/*"
require "timeouter"

module Retriable
  extend self

  def retriable(opts)
    local_config = Config.new(config.to_h.merge(opts))

    tries = local_config.tries
    base_interval = local_config.base_interval
    max_interval = local_config.max_interval
    rand_factor = local_config.rand_factor
    multiplier = local_config.multiplier
    max_elapsed_time = local_config.max_elapsed_time
    intervals = local_config.intervals
    timeout = local_config.timeout
    on_retry = local_config.on_retry
    sleep_disabled = local_config.sleep_disabled

    if intervals
      tries = intervals.size + 1
    else
      intervals = ExponentialBackoff.new(
        tries: tries - 1,
        base_interval: base_interval,
        multiplier: multiplier,
        max_interval: max_interval,
        rand_factor: rand_factor
      ).intervals
    end

    tries.times do |index|
      try = index + 1
      begin
        return yield try
      rescue exception : IO::Timeout
        interval = intervals[index]
        on_retry.call(exception, try, elapsed_time.call, interval) if on_retry
        raise if try >= tries || (elapsed_time.call + interval) > max_elapsed_time
        sleep interval if !sleep_disabled
      end
    end
  end
end
