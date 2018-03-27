require_relative "../spec_helper"

require_relative "../../lib/rack/wreck"
require_relative "../../lib/rack/wreck/delay"
require_relative "../../lib/rack/wreck/override"

describe "wreck" do
  it "configures using DSL" do
    Rack::Wreck.configure do
      override "/", chance: 0.1, status: 500
      override /widget/, chance: 0.05, status: 403, body: "Nice try!"
      delay "/slow", 3.seconds
    end

    assert_equal Rack::Wreck::Override.new("/", chance: 0.1, status: 500), Rack::Wreck.overrides[0]
    assert_equal Rack::Wreck::Override.new(/widget/, chance: 0.05, status: 403, body: "Nice try!"), Rack::Wreck.overrides[1]
    assert_equal Rack::Wreck::Delay.new("/slow", 3.seconds), Rack::Wreck.delays[0]
  end

  describe "call logic" do
    class TestWreck < Rack::Wreck
      def initialize(app, match)
        @match = match
        super(app)
      end

      def override(env)
        @match ? OpenStruct.new(call: "override call") : nil
      end

      def app_call(env)
        "app call"
      end
    end

    before do
      @app = Object.new
      @env = Object.new
    end

    it "calls override" do
      wreck = TestWreck.new(@app, true)
      assert_equal "override call", wreck.call(@env)
    end

    it "calls app" do
      wreck = TestWreck.new(@app, false)
      assert_equal "app call", wreck.call(@env)
    end
  end
end
