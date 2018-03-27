require_relative "../spec_helper"

require_relative "../../lib/rack/wreck"
require_relative "../../lib/rack/wreck/override"

describe "wreck" do
  it "configures overrides with DSL" do
    Rack::Wreck.configure do
      override "/", chance: 0.1, status: 500
      override /widget/, chance: 0.05, status: 403, body: "Nice try!"
    end

    assert_equal Rack::Wreck::Override.new("/", chance: 0.1, status: 500), Rack::Wreck.overrides[0]
    assert_equal Rack::Wreck::Override.new(/widget/, chance: 0.05, status: 403, body: "Nice try!"), Rack::Wreck.overrides[1]
  end
end
