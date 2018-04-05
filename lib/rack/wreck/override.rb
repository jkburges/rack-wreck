require_relative "rule"

module Rack
  class Wreck
    class Override < Rule
      attr_reader :status

      def self.null
        Override.new(/.*/, chance: 0)
      end

      def initialize(path = /.*/, opts = {})
        super(path, opts)

        @chance = opts[:chance]
        @status = opts.fetch(:status, 500)
        @body = [opts[:body]]
        @header = opts[:headers]
      end

      def call(&block)
        if fire?
          response
        else
          yield
        end
      end

      def fire?
        firing = Random.rand < chance
        logger.debug("Override firing: #{firing}")
        firing
      end

      def to_s
        fragments = []
        fragments << "override #{path.inspect}"
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

      def headers
        @headers || {}
      end

      def body
        @body || []
      end
    end
  end
end
