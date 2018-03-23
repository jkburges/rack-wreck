require "active_support"
require "active_support/core_ext/numeric"

module Rack
  class Wreck
    class Rule
      attr_reader :path, :method, :delay

      def initialize(path = /.*/, opts = {})
        @path = path
        @method = opts[:method]
        @chance = opts[:chance]
        @status = opts[:status]
        @delay = opts[:delay]
        @body = [opts[:body]]
        @header = opts[:headers]
      end

      def match(env)
        constraints = []

        constraints << env["PATH_INFO"].match(path)
        constraints << (method == env["REQUEST_METHOD"].downcase.to_sym) if method

        constraints.all?
      end

      def call(&block)
        res = if fire?
          response
        else
          yield
        end

        sleep(delay) if delay
        res
      end

      def fire?
        firing = Random.rand < chance
        logger.debug("Rule firing: #{firing}")
        firing
      end

      def to_s
        fragments = []
        fragments << "rule #{path.inspect}"
        fragments << "method: #{method.inspect}" if method
        fragments << %Q(chance: #{chance}, status: #{status}, body: "#{body.first}")

        fragments.join(", ")
      end

      def chance
        @chance || 1.0
      end

      def response
        [status, headers, body]
      end

      def status
        @status || 200
      end

      def headers
        @headers || {}
      end

      def body
        @body || []
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
