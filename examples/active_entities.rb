# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

# note: the following is just a simple example. before making any stats calls, make
# sure to read our best practices for analytics which can be found here:
#
# https://dev.twitter.com/ads/analytics/best-practices
# https://dev.twitter.com/ads/analytics/metrics-and-segmentation
# https://dev.twitter.com/ads/analytics/metrics-derived

require 'time'
require 'twitter-ads'

include TwitterAds::Enum

CONSUMER_KEY        = 'your consumer key'
CONSUMER_SECRET     = 'your consumer secret'
ACCESS_TOKEN        = 'user access token'
ACCESS_TOKEN_SECRET = 'user access token secret'
ADS_ACCOUNT         = 'ads account id'

# initialize the twitter ads api client
client = TwitterAds::Client.new(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  ACCESS_TOKEN,
  ACCESS_TOKEN_SECRET
)

# load up the account instance
account = client.accounts(ADS_ACCOUNT)

# for checking the active entities endpoint for the last day
time = Time.now
utc_offset = '+09:00'
start_time = time - (60 * 60 * 24) # -1 day
end_time = time

# active entities for line items
active_entities = TwitterAds::LineItem.active_entities(
  account,
  line_item_ids: %w(exrfs),
  start_time: start_time,
  end_time:   end_time,
  utc_offset: utc_offset,
  granularity: :day)

puts(active_entities)

# entity IDs to fetch analytics data for
# note: analytics endpoints support a
# maximum of 20 entity IDs per request
ids = active_entities.map { |entity| entity[:entity_id] }

# function for determining the start and end time
# to be used in the subsequent analytics request
# note: if `active_entities` is empty, `date_range` will error
def date_range(data)
  # Returns the minimum activity start time and the maximum activity end time
  # from the active entities response. These dates are modified in the following
  # way. The hours (and minutes and so on) are removed from the start and end
  # times and a *day* is added to the end time. These are the dates that should
  # be used in the subsequent analytics request.

  start_time = data.map { |entity| Time.parse(entity[:activity_start_time]) }.min
  end_time = data.map { |entity| Time.parse(entity[:activity_end_time]) }.max

  start_time = Time.new(
    start_time.year,
    start_time.month,
    start_time.day,
    start_time.hour,
    0,
    0,
    '+00:00')

  end_time = Time.new(
    end_time.year,
    end_time.month,
    end_time.day,
    end_time.hour,
    0,
    0,
    '+00:00') + (60 * 60 * 24) # +1 day

  [start_time, end_time]
end

start_time, end_time = date_range(active_entities)

# analytics request parameters
metric_groups = %W(#{MetricGroup::ENGAGEMENT})
granularity = Granularity::HOUR
placement = Placement::ALL_ON_TWITTER

# analytics request (synchronous)
data = TwitterAds::LineItem.stats(
  account,
  ids,
  metric_groups,
  granularity: granularity,
  placement: placement,
  start_time: start_time,
  end_time: end_time)

puts(data)
