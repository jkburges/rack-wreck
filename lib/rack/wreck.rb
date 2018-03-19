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
      # rules.each do |rule|
      #   if rule.match(env.path)
      #     rule.call do
      #       @app.call(env)
      #     end

      #     break
      #   end
      # end

      if Random.rand > 0.5
        [500, { "Content-Type" => "text/plain" }, ["Sucks to be you!\n"]]
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
