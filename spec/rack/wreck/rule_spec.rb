require_relative "../../spec_helper"

require_relative "../../../lib/rack/wreck/rule"

describe "rule" do
  describe "matching" do
    it "matches string" do
      assert Rack::Wreck::Rule.new("/foo").match("/foo")
      refute Rack::Wreck::Rule.new("/foo").match("/bar")
    end

    it "matches regex" do
      assert Rack::Wreck::Rule.new(/foo/).match("/foo/bar")
      assert Rack::Wreck::Rule.new(/foo/).match("/bar/foo/bar")
      assert Rack::Wreck::Rule.new(/foo/).match("/bar/foo")
      refute Rack::Wreck::Rule.new(/foo/).match("/bar")
    end
  end
end