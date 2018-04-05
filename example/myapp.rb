require "sinatra"
require "rack-wreck"

configure do
  use Rack::Wreck

  Rack::Wreck.configure do
    delay "/wow", amount: 2.seconds
    delay "/much"
    override "/wow",  chance: 0.3333, status: 500, body: "wow fail\n"
    override "/much", chance: 0.75,   status: 403, body: "much fail\n"
  end
end

get "/wow" do
  "wow\n"
end

get "/much" do
  "much\n"
end
