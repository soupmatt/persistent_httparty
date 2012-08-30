[![Build Status](https://secure.travis-ci.org/soupmatt/persistent_httparty.png?branch=master)](http://travis-ci.org/soupmatt/persistent_httparty)

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

* [httparty](/jnunemaker/httparty)
* [persistent_http](/bpardee/persistent_http)
* You like to Keep-Alive the party!

## Usage

Just call `persistent_connection_adapter` and then use HTTParty as
normal.

```ruby
class Twitter
  include HTTParty
  persistent_connection_adapter
end
```

## License

Distributed under the [MIT License](LICENSE)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
