require_relative "wreck/override"

module Rack
  class Wreck
    class << self
      attr_reader :delays, :overrides

      def configure(&block)
        @delays = []
        @overrides = []

        class_eval(&block)
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

    def call(env)
      matching_override = self.class.overrides.detect do |r|
        r.match(env)
      end

      if matching_override
        logger.debug("Matching override: #{matching_override}, env: #{env}")
        matching_override.call do
          @app.call(env)
        end
      else
        logger.debug("No matching override, env: #{env}")
        @app.call(env)
      end

      matching_delay = self.class.delays.detect do |r|
        r.match(env)
      end

      if matching_delay
        logger.debug("Matching delay: #{matching_delay}, env: #{env}")
        matching_delay.wait
      else
        logger.debug("No matching delay, env: #{env}")
      end
    end

    private

    def logger
      @logger ||= ::Logger.new(STDOUT)
    end
  end
end
