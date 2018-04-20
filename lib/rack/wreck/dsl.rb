require_relative "delay"
require_relative "override"

module Rack
  class Wreck
    module Dsl
      attr_reader :delays, :overrides

      def configure(&block)
        @delays = []
        @overrides = []

        class_eval(&block)

        @delays << Delay.null
        @overrides << Override.null
      end

      def delay(path, opts = {})
        @delays << Delay.new(path, opts)
      end

      def override(path, opts = {})
        @overrides << Override.new(path, opts)
      end
    end
  end
end
