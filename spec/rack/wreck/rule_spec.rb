require_relative "../../spec_helper"

require_relative "../../../lib/rack/wreck/rule"

describe "rule" do
  describe "matching" do
    it "matches string" do
      assert Rack::Wreck::Rule.new("/foo").match("PATH_INFO" => "/foo")
      refute Rack::Wreck::Rule.new("/foo").match("PATH_INFO" => "/bar")
      refute Rack::Wreck::Rule.new("/foo").match("PATH_INFO" => "/")
    end

    it "matches regex" do
      assert Rack::Wreck::Rule.new(/foo/).match("PATH_INFO" => "/foo/bar")
      assert Rack::Wreck::Rule.new(/foo/).match("PATH_INFO" => "/bar/foo/bar")
      assert Rack::Wreck::Rule.new(/foo/).match("PATH_INFO" => "/bar/foo")
      refute Rack::Wreck::Rule.new(/foo/).match("PATH_INFO" => "/bar")
    end

    it "matches HTTP method" do
      assert Rack::Wreck::Rule.new("/", method: :get).match("REQUEST_METHOD" => "GET", "PATH_INFO" => "/")
      refute Rack::Wreck::Rule.new("/", method: :post).match("REQUEST_METHOD" => "GET", "PATH_INFO" => "/")
      refute Rack::Wreck::Rule.new("/", method: :get).match("REQUEST_METHOD" => "POST", "PATH_INFO" => "/")
    end
  end

  describe "call" do
    it "calls on, on non fire?" do
      rule = Rack::Wreck::Rule.new("path", status: 500, body: "such fail")
      rule.stub(:fire?, true) do
        response = rule.call do
          [200, {}, ["worked"]]
        end

        assert_equal 500, response[0]
        assert_equal "such fail", response[2][0]
      end
    end

    it "returns fixed results, on fire?" do
      rule = Rack::Wreck::Rule.new("path", status: 500, body: "such fail")
      rule.stub(:fire?, false) do
        response = rule.call do
          [200, {}, ["worked"]]
        end

        assert_equal 200, response[0]
        assert_equal "worked", response[2][0]
      end
    end
  end

  describe "delays" do
    it "delays the reponse" do
      sleep_mock = Minitest::Mock.new
      sleep_mock.expect(:call, nil, [5.seconds])

      rule = Rack::Wreck::Rule.new("/", delay: 5.seconds)
      rule.stub(:sleep, sleep_mock) do
        rule.call
      end

      sleep_mock.verify
    end
  end

  describe "default response" do
    it "defaults to 200" do
      rule = Rack::Wreck::Rule.new
      rule.stub(:fire?, true) do
        response = rule.call
        assert_equal 200, response[0]
      end
    end
  end

  describe "formats itself as string" do
    it "when path is string" do
      rule = Rack::Wreck::Rule.new("path", chance: 0.1, status: 500, body: "such fail")
      assert_equal 'rule "path", chance: 0.1, status: 500, body: "such fail"', rule.to_s
    end

    it "when path is regex" do
      rule = Rack::Wreck::Rule.new(/matchme/, chance: 0.4, status: 403, body: "such fail")
      assert_equal 'rule /matchme/, chance: 0.4, status: 403, body: "such fail"', rule.to_s
    end

    it "includes method" do
      rule = Rack::Wreck::Rule.new("path", chance: 0.4, status: 403, method: :post)
      assert_equal 'rule "path", method: :post, chance: 0.4, status: 403, body: ""', rule.to_s
    end
  end
end
