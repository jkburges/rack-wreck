module Wreck
  class Wreck
    def initialize(app)
      @app = app
    end

    def call(env)
      if Random.rand > 0.95
        [500, { "Content-Type" => "text/plain" }, ["Sucks to be you!"]]
      else
        @app.call(env)
      end
    end
  end
end
