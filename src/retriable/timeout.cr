module Retriable
  class Timeout(T)
    def self.timeout(sec, &block: -> T)
      timeout = Channel(Bool).new
      result :: T
      spawn do
        sleep sec
        timeout.send true
      end

      spawn do
        result = block.call
        timeout.send false
      end

      raise IO::Timeout.new("Timeout after #{sec} seconds") if timeout.receive
      result
    end
  end
end
