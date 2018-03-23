# Rack::Wreck [![Build Status](https://travis-ci.org/jkburges/rack-wreck.svg?branch=master)](https://travis-ci.org/jkburges/rack-wreck)

Selectively cause requests to your rack app to fail - the idea being that by having an artifically flakey API, you are forced to build resilience in to your clients (à la [Chaos Monkey](https://github.com/Netflix/chaosmonkey) from Netflix).

## Getting started

Install the [Rack::Wreck](http://rubygems.org/gems/rack-wreck) gem; or add it to your Gemfile with bundler:

```ruby
# In your Gemfile
gem 'rack-wreck'
```
Tell your app to use the Rack::Wreck middleware.
For Rails apps:

```ruby
# In config/application.rb
config.middleware.use Rack::Wreck
```

Or for Rackup files:

```ruby
# In config.ru
require "rack/wreck"
use Rack::Wreck
```

See [examples](example) for example apps/configrations.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jkburges/rack-wreck. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Thanks to the [rack-attack](https://github.com/kickstarter/rack-attack) gem for providing a great basis for writing rack middleware!

## Todo

* rules matched top to bottom

* what to fail?
  * block which takes rack env

* when to fail?
  * MVP - `Random.rand > x `
  * extend to https://github.com/clbustos/distribution

* how to fail?
  * the normal Rack response, e.g. `['500', {'Content-Type' => 'text/html'}, ["You've been wrecked!"]]`

### Example configuration

```ruby
Rack::Wreck.rules do
  rule "/login", method: :post, chance: 0.1,  status: 500
  rule /widget/, chance: 0.05, status: 403, body: "Nice try!" 
end
```

It's also possible to delay responses as follows:

```ruby
Rack::Wreck.configure do
  rule "/expensive", delay: 5.seconds
  # TODO: distributions from https://github.com/clbustos/distribution
end
```

This configuration will fail (on average) 1 in every 10 `login` requests with an HTTP `500 Server Error`. Likewise, requests to any endpoints matching the `/widget/` regular expression will fail 1 in every 20 times with an HTTP `403 Forbidden`.
