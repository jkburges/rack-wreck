module Rack
  class Wreck
    class Rule
      attr_reader :path

      def initialize(path = /.*/, opts = {})
        @path = path
        @chance = opts[:chance]
        @status = opts[:status]
        @body = [opts[:body]]
        @header = opts[:headers]
      end

      def match(p)
        p.match(path)
      end

      def call(&block)
        if fire?
          response
        else
          yield
        end
      end

      def fire?
        Random.rand < chance
      end

      def to_s
        %Q(rule #{path.inspect}, chance: #{chance}, status: #{status}, body: "#{body.first}")
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
    end
  end
end