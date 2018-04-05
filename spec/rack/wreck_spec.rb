require_relative "../spec_helper"

require_relative "../../lib/rack/wreck"
require_relative "../../lib/rack/wreck/delay"
require_relative "../../lib/rack/wreck/override"

describe "wreck" do
  describe "DSL" do
    it "configures overrides" do
      Rack::Wreck.configure do
        override "/", chance: 0.1, status: 500
        override /widget/, chance: 0.05, status: 403, body: "Nice try!"
      end

      assert_equal Rack::Wreck::Override.new("/", chance: 0.1, status: 500), Rack::Wreck.overrides[0]
      assert_equal Rack::Wreck::Override.new(/widget/, chance: 0.05, status: 403, body: "Nice try!"), Rack::Wreck.overrides[1]
      assert_equal Rack::Wreck::Override.null, Rack::Wreck.overrides.last
    end

    it "configures delays" do
      Rack::Wreck.configure do
        delay "/slow", duration: 3.seconds
      end

      assert_equal Rack::Wreck::Delay.new("/slow", duration: 3.seconds), Rack::Wreck.delays[0]
      assert_equal Rack::Wreck::Delay.null, Rack::Wreck.delays.last
    end
  end

  describe "call logic" do
    class TestWreck < Rack::Wreck
      def delay(env)
        OpenStruct.new(call: "delay call")
      end

      def override(env)
        OpenStruct.new(call: "override call")
      end
    end

    before do
      @app = Object.new
      @env = Object.new
    end

    it "calls override" do
      wreck = TestWreck.new(@app)
      assert_equal "override call", wreck.call(@env)
    end
  end
end
