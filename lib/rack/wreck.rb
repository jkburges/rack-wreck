require_relative "wreck/delay"
require_relative "wreck/override"

module Rack
  class Wreck
    class << self
      attr_reader :delays, :overrides

      def configure(&block)
        @delays = []
        @overrides = []

        class_eval(&block)

        @delays << Delay.null
        @overrides << Override.null
      end

      def delay(path, opts)
        @delays << Delay.new(path, opts)
      end

      def override(path, opts)
        @overrides << Override.new(path, opts)
      end
    end

    def initialize(app)
      @app = app
    end

    def delay(env)
      self.class.delays.detect do |r|
        r.match(env)
      end
    end

    def override(env)
      self.class.overrides.detect do |r|
        r.match(env)
      end
    end

    def call(env)
      result = override(env).call do
        @app.call(env)
      end

      delay(env).call

      result
    end

    private

    def logger
      @logger ||= ::Logger.new(STDOUT)
    end
  end
end
