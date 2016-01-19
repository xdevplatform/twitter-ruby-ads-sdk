# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

# note: the following is just a simple example. before making any stats calls, make
# sure to read our best practices for analytics which can be found here:
#
# https://dev.twitter.com/ads/analytics/best-practices
# https://dev.twitter.com/ads/analytics/metrics-and-segmentation
# https://dev.twitter.com/ads/analytics/metrics-derived

require 'twitter-ads'

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

# limit request count and grab the first 10 line items from TwitterAds::Cursor
line_items = account.line_items(nil, count: 10)[0..9]

# the list of metrics we want to fetch, for a full list of possible metrics
# see: https://dev.twitter.com/ads/analytics/metrics-and-segmentation
metrics = [:billed_engagements, :billed_follows]

# fetching stats on the instance
line_items.first.stats(metrics)

# fetching stats for multiple line items
ids = line_items.map(&:id)
TwitterAds::LineItem.stats(account, ids, metrics)
