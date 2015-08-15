# Copyright (C) 2015 Twitter, Inc.

require 'simplecov'
require 'codeclimate-test-reporter'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage(85.00)
end

require 'rubocop'
require 'faker'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow: 'codeclimate.com')

require 'twitter-ads'
include TwitterAds

# Require All Support Files
Dir['./spec/support/*.rb'].sort.each { |file| require file }

ADS_API    = 'https://ads-api.twitter.com/0'
TON_API    = 'https://ton.twitter.com'
UPLOAD_API = 'https://upload.twitter.com/1.1'

RSpec.configure do |config|
  # Helpers & Custom Matchers
  include Helpers

  # General
  config.color     = true
  config.fail_fast = true unless ENV['CI']
  config.formatter = ENV['CI'] ? 'documentation' : 'progress'
  config.profile_examples = 5

  # Expectations
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Mocking
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Test Order & Filtering
  config.order = :random
  Kernel.srand config.seed
end

# Require All Shared Examples
Dir['./spec/shared/*.rb'].sort.each { |file| require file }
