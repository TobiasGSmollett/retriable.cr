module Retriable
  class Config
    ATTRIBUTES = ExponentialBackoff::ATTRIBUTES + [
      :sleep_disabled,
      :max_elapsed_time,
      :intervals,
      :timeout,
      :on,
      :on_retry,
      :contexts
    ]

    def initialize(opts = {})
      backoff = ExponentialBackoff.new

      @tries = backoff.tries
      @base_interval = backoff.base_interval
      @max_interval = backoff.max_interval
      @rand_factor = backoff.rand_factor
      @multiplier = backoff.multiplier
      @sleep_disabled = false
      @max_elapsed_time = 900 # 15 min
      @intervals = nil
      @timeout = nil
      #@on = [StandardError]
      @on_retry = nil
      @contexts = {}

      yield self
    end
  end
end
