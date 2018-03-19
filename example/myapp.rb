require "sinatra"
require "rack-wreck"

configure do
  use Rack::Wreck
end

get "/" do
  "Hello world!\n"
end
