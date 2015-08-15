source 'https://rubygems.org'

gemspec
gem 'rake'

group :development, :test do
  gem 'faker'
  gem 'rubocop', '0.30'
  gem 'rspec'
  gem 'cucumber'
  gem 'coveralls', require: false
  gem 'webmock'
  gem 'codeclimate-test-reporter'
end

group :development do
  gem 'pry-nav', require: true
  gem 'pry-rescue'

  gem 'rb-fchange', require: false # Windows
  gem 'rb-fsevent', require: false # OS X
  gem 'rb-inotify', require: false # Linux
  gem 'terminal-notifier-guard'

  gem 'guard-bundler'
  gem 'guard-rspec', platforms: :mri
  gem 'guard-jruby-rspec', platforms: :jruby

  gem 'ruby-prof', platforms: :mri

  gem 'yard'
  gem 'git'
  gem 'redcarpet'
end
