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

# load up the account instance
account = client.accounts(ADS_ACCOUNT)

# create your campaign
campaign = TwitterAds::Campaign.new(account)
campaign.funding_instrument_id = account.funding_instruments.first.id
campaign.daily_budget_amount_local_micro = 1_000_000
campaign.name = 'my first campaign'
campaign.entity_status = EntityStatus::PAUSED
campaign.start_time = Time.now.utc
campaign.save

# create a line item for the campaign
line_item = TwitterAds::LineItem.new(account)
line_item.campaign_id            = campaign.id
line_item.name                   = 'my first ad'
line_item.product_type           = Product::PROMOTED_TWEETS
line_item.placements             = [Placement::ALL_ON_TWITTER]
line_item.objective              = Objective::TWEET_ENGAGEMENTS
line_item.bid_amount_local_micro = 10_000
line_item.entity_status          = EntityStatus::PAUSED
line_item.save

# add targeting criteria
targeting_criteria = TwitterAds::TargetingCriteria.new(account)
targeting_criteria.line_item_id = line_item.id
targeting_criteria.targeting_type = 'LOCATION'
targeting_criteria.targeting_value = '00a8b25e420adc94'
targeting_criteria.save
