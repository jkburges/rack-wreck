require_relative "../../spec_helper"

require_relative "../../../lib/rack/wreck/override"

describe "override" do
  describe "matching" do
    it "matches string" do
      assert Rack::Wreck::Override.new("/foo").match("PATH_INFO" => "/foo")
      refute Rack::Wreck::Override.new("/foo").match("PATH_INFO" => "/bar")
      refute Rack::Wreck::Override.new("/foo").match("PATH_INFO" => "/")
    end

    it "matches regex" do
      assert Rack::Wreck::Override.new(/foo/).match("PATH_INFO" => "/foo/bar")
      assert Rack::Wreck::Override.new(/foo/).match("PATH_INFO" => "/bar/foo/bar")
      assert Rack::Wreck::Override.new(/foo/).match("PATH_INFO" => "/bar/foo")
      refute Rack::Wreck::Override.new(/foo/).match("PATH_INFO" => "/bar")
    end

    it "matches HTTP method" do
      assert Rack::Wreck::Override.new("/", method: :get).match("REQUEST_METHOD" => "GET", "PATH_INFO" => "/")
      refute Rack::Wreck::Override.new("/", method: :post).match("REQUEST_METHOD" => "GET", "PATH_INFO" => "/")
      refute Rack::Wreck::Override.new("/", method: :get).match("REQUEST_METHOD" => "POST", "PATH_INFO" => "/")
    end
  end

  describe "call" do
    it "calls on, on non fire?" do
      override = Rack::Wreck::Override.new("path", status: 500, body: "such fail")
      override.stub(:fire?, true) do
        response = override.call do
          [200, {}, ["worked"]]
        end

        assert_equal 500, response[0]
        assert_equal "such fail", response[2][0]
      end
    end

    it "returns fixed results, on fire?" do
      override = Rack::Wreck::Override.new("path", status: 500, body: "such fail")
      override.stub(:fire?, false) do
        response = override.call do
          [200, {}, ["worked"]]
        end

        assert_equal 200, response[0]
        assert_equal "worked", response[2][0]
      end
    end
  end

  describe "default response" do
    it "defaults to 200" do
      override = Rack::Wreck::Override.new
      override.stub(:fire?, true) do
        response = override.call
        assert_equal 200, response[0]
      end
    end
  end

  describe "formats itself as string" do
    it "when path is string" do
      override = Rack::Wreck::Override.new("path", chance: 0.1, status: 500, body: "such fail")
      assert_equal 'override "path", chance: 0.1, status: 500, body: "such fail"', override.to_s
    end

    it "when path is regex" do
      override = Rack::Wreck::Override.new(/matchme/, chance: 0.4, status: 403, body: "such fail")
      assert_equal 'override /matchme/, chance: 0.4, status: 403, body: "such fail"', override.to_s
    end

    it "includes method" do
      override = Rack::Wreck::Override.new("path", chance: 0.4, status: 403, method: :post)
      assert_equal 'override "path", method: :post, chance: 0.4, status: 403, body: ""', override.to_s
    end
  end
end
