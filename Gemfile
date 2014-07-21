source 'https://rubygems.org'

# Specify your gem's dependencies in persistent_httparty.gemspec
gemspec

group :tools do
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  group :darwin do
    gem 'ruby_gntp'
    gem 'rb-fsevent'
  end
end unless RUBY_VERSION < "1.9.3"

gem 'json', :platform => :mri_18

platform :rbx do
  gem 'rubysl'
end
