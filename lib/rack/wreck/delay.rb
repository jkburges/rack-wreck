require "active_support"
require "active_support/core_ext/numeric"

module Rack
  class Wreck
    class Delay
      attr_reader :path, :amount, :method

      def self.null
        Delay.new(/.*/, amount: 0)
      end

      def initialize(path = /.*/, amount = 1.seconds, opts = {})
        @path = path
        @amount = amount
        @method = opts[:method]
      end

      def match(env)
        constraints = []

        constraints << env["PATH_INFO"].match(path)
        constraints << (method == env["REQUEST_METHOD"].downcase.to_sym) if method

        constraints.all?
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

      def ==(other)
        other.class == self.class && other.state == self.state
      end

      def state
        self.instance_variables.map { |variable| self.instance_variable_get variable }
      end

      private

      def logger
        @logger ||= ::Logger.new(STDOUT)
      end
    end
  end
end
