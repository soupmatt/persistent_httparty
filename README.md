[![Build Status](https://secure.travis-ci.org/soupmatt/persistent_httparty.png?branch=master)](http://travis-ci.org/soupmatt/persistent_httparty)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/soupmatt/persistent_httparty)

# persistent_httparty

Persistent HTTP connections for HTTParty!

## Installation

Add this line to your application's Gemfile:

    gem 'persistent_httparty'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install persistent_httparty

## Requirements

* [httparty](/jnunemaker/httparty) and [persistent_http](/bpardee/persistent_http)
* You like to `Keep-Alive` the party!

## Usage

Just call `persistent_connection_adapter` and then use HTTParty as
normal.

```ruby
class Twitter
  include HTTParty
  persistent_connection_adapter
end
```

You can also pass in parameters to the `persistent_http` gem. The
regular HTTParty config will be passed through as applicable.

```ruby
class MyCoolRestClient
  include HTTParty
  persistent_connection_adapter { :name => 'my_cool_rest_client',
                                  :pool_size => 2,
                                  :idle_timeout => 10,
                                  :keep-alive => 30 }
end
```

## License

Distributed under the [MIT License](/soupmatt/persistent_httparty/blob/master/LICENSE)

## Special Thanks

* To @jnunemaker for maintaining a tight ship on the extremely useful
[httparty](/jnunemaker/httparty)
* To @bpardee for writing the best persistent http connection library
  for ruby I've found in [persistent_http](/bpardee/persistent_http)
* To @vibes for letting me open source as much of the work I do there
  as possible.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
