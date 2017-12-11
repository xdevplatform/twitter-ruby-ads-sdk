# frozen_string_literal: true
source 'https://rubygems.org'

gemspec
gem 'rake'

group :development, :test do
  gem 'codeclimate-test-reporter', platforms: :mri
  gem 'cucumber'
  gem 'faker'
  gem 'rspec'
  gem 'rubocop', '~> 0.48.0'
  gem 'simplecov', '0.10' # fix for breaking change in simplecov
  gem 'webmock'
end

group :development do
  gem 'guard-bundler', platforms: :mri
  gem 'guard-rspec', platforms: :mri
  gem 'pry-nav', require: true
  gem 'pry-rescue', require: true

  gem 'rb-fchange', require: false # Windows
  gem 'rb-fsevent', require: false # OS X
  gem 'rb-inotify', require: false # Linux
  gem 'terminal-notifier-guard'

  gem 'ruby-prof', platforms: :mri
end

group :release do
  gem 'colorize'
  gem 'git'
  gem 'redcarpet', platforms: :mri
  gem 'yard'
end
