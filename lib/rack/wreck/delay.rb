require "active_support"
require "active_support/core_ext/numeric"
require_relative "rule"

module Rack
  class Wreck
    class Delay < Rule
      attr_reader :amount

      def self.null
        Delay.new(/.*/, amount: 0)
      end

      def initialize(path = /.*/, amount = 1.seconds, opts = {})
        super(path, opts)

        @amount = amount
      end

      def exec
        sleep(amount)
      end

      def to_s
        fragments = []
        fragments << "delay #{path.inspect}"
        fragments << amount
        fragments << "method: #{method.inspect}" if method

        fragments.join(", ")
      end
    end
  end
end
