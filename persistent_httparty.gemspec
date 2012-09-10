# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'persistent_httparty/version'

Gem::Specification.new do |gem|
  gem.name          = "persistent_httparty"
  gem.version       = PersistentHttparty::VERSION
  gem.authors       = ["Matt Campbell"]
  gem.email         = ["persistent_httparty@soupmatt.com"]
  gem.description   = %q{Persistent HTTP connections for HTTParty using the persistent_http gem. Keep the party alive!}
  gem.summary       = %q{Persistent HTTP connections for HTTParty}
  gem.homepage      = "https://github.com/soupmatt/persistent_httparty"

  gem.files            = `git ls-files -- lib/*`.split("\n")
  gem.files           += %w[README.md LICENSE CHANGELOG.md]
  gem.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_dependency "httparty", "~> 0.9.0"
  gem.add_dependency "persistent_http"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "cucumber"
  gem.add_development_dependency "webmock"
end
