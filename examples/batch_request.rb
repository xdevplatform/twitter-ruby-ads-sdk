# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'twitter-ads'
include TwitterAds::Enum

CONSUMER_KEY        = 'your consumer key'.freeze
CONSUMER_SECRET     = 'your consumer secret'.freeze
ACCESS_TOKEN        = 'user access token'.freeze
ACCESS_TOKEN_SECRET = 'user access token secret'.freeze
ACCOUNT_ID          = 'ads account id'.freeze

# initialize the client
client = TwitterAds::Client.new(CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

# load the advertiser account instance
account = client.accounts(ACCOUNT_ID)

# create two campaigns
campaign_1 = TwitterAds::Campaign.new(account)
campaign_1.funding_instrument_id = account.funding_instruments.first.id
campaign_1.daily_budget_amount_local_micro = 1_000_000
campaign_1.name = 'my first campaign'
campaign_1.entity_status = EntityStatus::PAUSED
campaign_1.start_time = Time.now.utc

campaign_2 = TwitterAds::Campaign.new(account)
campaign_2.funding_instrument_id = account.funding_instruments.first.id
campaign_2.daily_budget_amount_local_micro = 2_000_000
campaign_2.name = 'my second campaign'
campaign_2.entity_status = EntityStatus::PAUSED
campaign_2.start_time = Time.now.utc

campaigns_list = [campaign_1, campaign_2]
TwitterAds::Campaign.batch_save(account, campaigns_list)

# modify the created campaigns
campaign_1.name = 'my modified first campaign'
campaign_2.name = 'my modified second campaign'

TwitterAds::Campaign.batch_save(account, campaigns_list)

# create line items for campaign_1
line_item_1 = TwitterAds::LineItem.new(account)
line_item_1.campaign_id = campaign_1.id
line_item_1.name = 'my first ad'
line_item_1.product_type = TwitterAds::Product::PROMOTED_TWEETS
line_item_1.placements = [TwitterAds::Placement::ALL_ON_TWITTER]
line_item_1.objective = TwitterAds::Objective::TWEET_ENGAGEMENTS
line_item_1.bid_amount_local_micro = 10_000
line_item_1.entity_status = EntityStatus::PAUSED

line_item_2 = TwitterAds::LineItem.new(account)
line_item_2.campaign_id = campaign_1.id
line_item_2.name = 'my second ad'
line_item_2.product_type = TwitterAds::Product::PROMOTED_TWEETS
line_item_2.placements = [TwitterAds::Placement::ALL_ON_TWITTER]
line_item_2.objective = TwitterAds::Objective::TWEET_ENGAGEMENTS
line_item_2.bid_amount_local_micro = 20_000
line_item_2.entity_status = EntityStatus::PAUSED

line_items_list = [line_item_1, line_item_2]
TwitterAds::LineItem.batch_save(account, line_items_list)

# create targeting criteria for line_item_1
targeting_criterion_1 = TwitterAds::TargetingCriteria.new(account)
targeting_criterion_1.line_item_id = line_item_1.id
targeting_criterion_1.targeting_type = 'LOCATION'
targeting_criterion_1.targeting_value = '00a8b25e420adc94'

targeting_criterion_2 = TwitterAds::TargetingCriteria.new(account)
targeting_criterion_2.line_item_id = line_item_1.id
targeting_criterion_2.targeting_type = 'PHRASE_KEYWORD'
targeting_criterion_2.targeting_value = 'righteous dude'

targeting_criteria_list = [targeting_criterion_1, targeting_criterion_2]
TwitterAds::TargetingCriteria.batch_save(account, targeting_criteria_list)

targeting_criterion_1.to_delete = true
targeting_criterion_2.to_delete = true

TwitterAds::TargetingCriteria.batch_save(account, targeting_criteria_list)

line_item_1.to_delete = true
line_item_2.to_delete = true

TwitterAds::LineItem.batch_save(account, line_items_list)

campaign_1.to_delete = true
campaign_2.to_delete = true

TwitterAds::Campaign.batch_save(account, campaigns_list)
