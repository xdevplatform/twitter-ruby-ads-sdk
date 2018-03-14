# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

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

# load up the account
account = client.accounts(ADS_ACCOUNT)

# get video object
ml = TwitterAds::Creative::MediaLibrary.all(account, media_type: TwitterAds::Enum::MediaType::VIDEO)
media_key = ml.first.media_key

# create poll card with video
pc = TwitterAds::Creative::PollCard.new(account)
pc.duration_in_minutes = 10080 # one week
pc.first_choice = 'Northern'
pc.second_choice = 'Southern'
pc.name = '%{media_name} poll card from SDK' % { media_name: ml.first.name }
pc.media_key = media_key
pc.save

# create Tweet
TwitterAds::Tweet.create(account, text: 'Which hemisphere do you prefer?', card_uri: pc.card_uri)
