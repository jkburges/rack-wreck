require_relative "wreck/dsl"

module Rack
  class Wreck
    class << self
      include Dsl
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
