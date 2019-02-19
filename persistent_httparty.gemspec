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

  if RUBY_VERSION >= "1.9.3"
    gem.add_dependency "httparty", "~> 0.9"
  else
    gem.add_dependency "httparty", ">= 0.9", "< 0.12"
  end
  gem.add_dependency "persistent_http", "< 2"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 3.8"
  gem.add_development_dependency "rspec-its"
  gem.add_development_dependency "cucumber"
  gem.add_development_dependency "webmock"
end
