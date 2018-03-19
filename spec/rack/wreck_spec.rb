require_relative "../spec_helper"

require_relative "../../lib/rack/wreck"
require_relative "../../lib/rack/wreck/rule"

describe "wreck" do
  it "configures rules with DSL" do
    Rack::Wreck.configure do
      rule "/", chance: 0.1, status: 500
      rule /widget/, chance: 0.05, status: 403, body: "Nice try!"
    end

    assert_equal Rack::Wreck::Rule.new("/", chance: 0.1, status: 500), Rack::Wreck.rules[0]
    assert_equal Rack::Wreck::Rule.new(/widget/, chance: 0.05, status: 403, body: "Nice try!"), Rack::Wreck.rules[1]
  end
end
