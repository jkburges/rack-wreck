module Rack
  class Wreck
    def initialize(app)
      @app = app
    end

    def call(env)
      # rules.each do |rule|
      #   if rule.match(env.path)
      #     rule.call do
      #       @app.call(env)
      #     end

      #     break
      #   end
      # end

      if Random.rand > 0.5
        [500, { "Content-Type" => "text/plain" }, ["Sucks to be you!\n"]]
      else
        @app.call(env)
      end
    end
  end
end
