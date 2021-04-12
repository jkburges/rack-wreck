require "active_support"
require "active_support/core_ext/numeric"
require_relative "rule"

module Rack
  class Wreck
    class Delay < Rule
      attr_reader :duration

      def self.null
        Delay.new(/.*/, duration: 0)
      end

      def initialize(path = /.*/, opts = {})
        super(path, opts)

        @duration = opts.fetch(:duration, 1.second)
      end

      def call
        logger.debug("Delay (s): #{duration}")
        sleep(duration)
      end

      def to_s
        fragments = []
        fragments << "delay #{path.inspect}"
        fragments << duration
        fragments << "method: #{method.inspect}" if method

        fragments.join(", ")
      end
    end
  end
end
