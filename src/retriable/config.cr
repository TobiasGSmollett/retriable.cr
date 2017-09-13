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

    property tries : Int32
    property base_interval : Float64
    property max_interval : Float64
    property rand_factor : Float64
    property multiplier : Float64
    property sleep_disabled : Boolean
    property max_elapsed_time : Float64
    property intervals : Array(Float64)
    property timeout : Float64
    property on_retry : Int32 ->


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
      #@contexts = {}

      yield self
    end
  end
end
