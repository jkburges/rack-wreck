require_relative "rule"

module Rack
  class Wreck
    class Override < Rule
      attr_reader :body, :chance, :headers, :status

      def self.null
        Override.new(/.*/, chance: 0)
      end

      def initialize(path = /.*/, opts = {})
        super(path, opts)

        @chance = opts.fetch(:chance, 1.0)
        @status = opts.fetch(:status, 500)
        @body = opts.fetch(:body, [])
        @headers = opts.fetch(:headers, {})
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
        fragments << %Q(chance: #{chance}, status: #{status}, body: "#{body}")

        fragments.join(", ")
      end

      def response
        [status, headers, body]
      end
    end
  end
end
