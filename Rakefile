#!/usr/bin/env ruby

# Copyright (C) 2015 Twitter, Inc.

require 'rubygems'

begin
  require 'bundler'
  require 'bundler/gem_tasks'
rescue LoadError
  raise '[FAIL] Bundler not found! Install it with ' \
        '`gem install bundler; bundle install`.'
end

# Default Rake Task
if ENV['CI']
  task default: ['spec', 'coveralls:push'] # 'features'
  Bundler.require(:default, :testing)
else
  task default: ['spec'] # 'features'
  Bundler.require(:default, :testing, :development, :release)
end

# Cucumber Setup
require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format progress --strict'
end

# RSpec Setup
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Coveralls Setup
require 'coveralls/rake/task'
Coveralls::RakeTask.new
