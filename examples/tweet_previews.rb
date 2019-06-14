# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.
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

# load up the account instance, campaign and line item
account = client.accounts(ADS_ACCOUNT)

preview = TwitterAds::Creative::TweetPreview.new(account)
tweets = preview.load(
  account,
  tweet_ids: %w(1130942781109596160 1101254234031370240),
  tweet_type: TweetType::PUBLISHED)

tweets.each { |tweet|
  puts(tweet.tweet_id)
  puts(tweet.preview)
}
