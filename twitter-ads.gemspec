# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require File.expand_path('../lib/twitter-ads/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'twitter-ads'
  s.version     = TwitterAds::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = [
    'John Babich',
    'Tushar Bhushan',
    'Juan Shishido',
    'Thomas Osowski',
    'Shohei Maeda'
  ]
  s.email       = ['twitterdev-ads@twitter.com']
  s.homepage    = 'https://github.com/twitterdev/twitter-ruby-ads-sdk'
  s.description = 'The officially supported Twitter Ads API SDK for Ruby.'
  s.summary     = s.description

  s.required_ruby_version     = '>= 2.4.0'
  s.required_rubygems_version = '>= 2.6.0'

  if File.exist?('private.pem')
    s.signing_key = 'private.pem'
    s.cert_chain  = ['public.pem']
  else
    warn 'WARNING:  No private key present, creating unsigned gem.'
  end

  s.add_dependency 'multi_json', '~> 1.11'
  s.add_dependency 'oauth', '~> 0.4'

  s.files = Dir.glob('{bin,lib}/**/*')
  s.files += %w(twitter-ads.gemspec LICENSE README.md CONTRIBUTING.md Rakefile)
  s.test_files = Dir.glob('{spec,feature}/**/*')
  s.executables = 'twitter-ads'
  s.require_paths = ['lib']
end
