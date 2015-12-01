source 'https://rubygems.org'

gemspec
gem 'rake'

group :development, :test do
  gem 'faker'
  gem 'rubocop', '0.30'
  gem 'rspec'
  gem 'cucumber'
  gem 'webmock'
  gem 'codeclimate-test-reporter', platforms: :mri
  gem 'simplecov', '0.10' # fix for breaking change in simplecov
end

group :development do
  gem 'pry-nav', require: true
  gem 'pry-rescue', require: true

  gem 'rb-fchange', require: false # Windows
  gem 'rb-fsevent', require: false # OS X
  gem 'rb-inotify', require: false # Linux
  gem 'terminal-notifier-guard'

  gem 'guard-bundler', platforms: :mri
  gem 'guard-rspec', platforms: :mri
  gem 'ruby-prof', platforms: :mri
end

group :release do
  gem 'redcarpet', platforms: :mri
  gem 'yard'
  gem 'git'
  gem 'colorize'
end
