module Rack
  class Wreck
    class Rule
      attr_reader :path, :method

      def initialize(path = /.*/, opts = {})
        @path = path
        @method = opts[:method]
      end

      def match(env)
        constraints = []

        constraints << env["PATH_INFO"].match(path)
        constraints << (method == env["REQUEST_METHOD"].downcase.to_sym) if method

        constraints.all?
      end

      def ==(other)
        other.class == self.class && other.state == self.state
      end

      def state
        self.instance_variables.map { |variable| self.instance_variable_get variable }
      end

      protected

      def logger
        @logger ||= ::Logger.new(STDOUT)
      end
    end
  end
end
