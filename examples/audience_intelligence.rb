# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.
require 'twitter-ads'
include TwitterAds::Enum

CONSUMER_KEY        = 'your consumer key'.freeze
CONSUMER_SECRET     = 'your consumer secret'.freeze
ACCESS_TOKEN        = 'user access token'.freeze
ACCESS_TOKEN_SECRET = 'user access token secret'.freeze
ADS_ACCOUNT         = 'ads account id'.freeze

# initialize the twitter ads api client
client = TwitterAds::Client.new(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  ACCESS_TOKEN,
  ACCESS_TOKEN_SECRET
)

# load up the account instance, campaign and line item
account = client.accounts(ADS_ACCOUNT)

audience_conversations = TwitterAds::AudienceIntelligence.new(account)
audience_conversations.conversation_type = ConversationType::HASHTAG
audience_conversations.audience_definition = AudienceDefinition::TARGETING_CRITERIA

targeting_inputs =
  [{
    targeting_type: 'GENDER',
    targeting_value: '2'
  }, {
    targeting_type: 'AGEBUCKET',
    targeting_value: 'AGE_OVER_50'
  }]

audience_conversations.targeting_inputs = targeting_inputs
# returns a cursor instance
response = audience_conversations.conversations
response.each do |ai|
  puts ai.localized[:targeting_type]
  puts ai.localized[:targeting_value]
  puts '\n'
end

audience_demographics = TwitterAds::AudienceIntelligence.new(account)
audience_demographics.audience_definition = AudienceDefinition::KEYWORD_AUDIENCE
audience_demographics.targeting_inputs =
  [{
    targeting_type: 'BROAD_MATCH_KEYWORD',
    targeting_value: 'womensmarch2018',
    start_time: '2017-12-31'
  }]
# returns raw response body
demographics = audience_demographics.demographics
demographics.each do |demo|
  puts demo
  puts "\n"
end
