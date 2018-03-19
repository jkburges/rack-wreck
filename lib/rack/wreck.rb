require_relative "wreck/rule"

module Rack
  class Wreck
    class << self
      attr_reader :rules

      def configure(&block)
        @rules = []
        class_eval(&block)
      end

      def rule(path, opts)
        @rules << Rule.new(path, opts)
      end
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      matching_rule = self.class.rules.detect do |r|
        r.match(env["PATH_INFO"])
      end

      if matching_rule
        matching_rule.call do
          @app.call(env)
        end
      else
        @app.call(env)
      end
    end

    private

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
