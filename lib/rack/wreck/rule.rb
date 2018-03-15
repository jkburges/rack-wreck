module Rack
  class Wreck
    class Rule
      attr_reader :path

      def initialize(path, opts = {})
        @path = path
      end

      def match(p)
        path.match(p)
      end
    end
  end
end