module Wreck
  class Wreck
    def initialize(app)
      @app = app
    end

    def call(env)
      puts "Wreck in action!"
      @app.call(env)
    end
  end
end
