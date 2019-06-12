#!/usr/bin/env ruby
# frozen_string_literal: true

# Copyright (C) 2019 Twitter, Inc.

require 'rubygems'

begin
  require 'bundler'
  require 'bundler/gem_tasks'
rescue LoadError
  raise '[FAIL] Bundler not found! Install it with ' \
        '`gem install bundler; bundle install`.'
end

# Helper for making a bit of log noise.
def announce(type, message, &block)
  print "[#{type.to_s.upcase}] #{message}... "
  begin
    yield block
    print "[DONE]\n".colorize(color: :green).bold
  rescue StandardError
    print "[FAILED]\n".colorize(color: :red).bold
    abort
  end
end

# Default Rake Task
if ENV['CI']
  task default: ['spec'] # 'features'
  Bundler.require(:default, :test)
else
  task default: ['spec'] # 'features'
  Bundler.require(:default, :test, :development, :release)
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

unless ENV['CI']
  # Release and Deployment
  desc 'Builds the latest SDK docs locally'
  task :docs do
    FileUtils.rm_rf('doc')
    YARD::CLI::CommandParser.run('--quiet')
  end

  namespace :docs do
    git = Git.open(File.expand_path('../', __FILE__))

    desc 'Builds and deploys the latest SDK docs'
    task :deploy do
      unless git.status.changed.empty?
        puts 'Error! Cannot proceeed, you have pending changes.'.colorize(color: :red).bold
        abort
      end
      FileUtils.rm_rf('doc')
      YARD::CLI::CommandParser.run

      current_branch = git.branch.name
      announce(:build, "updating v#{TwitterAds::VERSION} documentation") do
        git.branch('gh-pages').checkout
        FileUtils.rm_rf('reference')
        FileUtils.mv('doc', 'reference')
        git.add('reference')
        git.commit("[docs] updating v#{TwitterAds::VERSION} documentation")
      end

      announce(:push, "publishing v#{TwitterAds::VERSION} documentation") do
        git.push('origin', 'gh-pages')
      end

      git.branch(current_branch).checkout
    end
  end

end
