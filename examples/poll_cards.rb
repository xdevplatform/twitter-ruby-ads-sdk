# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require_relative '../lib/twitter-ads'
require_relative '../lib/twitter-ads/creative/poll_cards.rb'
require_relative '../lib/twitter-ads/creative/media_library.rb'
require_relative '../lib/twitter-ads/enum.rb'
require_relative '../lib/twitter-ads/version.rb'

CONSUMER_KEY        = 'S7JRickwIaCFAxvbHp5IklyeZ'.freeze
CONSUMER_SECRET     = 'TODBTfo4kiERkhmBvdV3ruEhztmOnOgtOI9uu5Rd4UzpQMDttm'.freeze
ACCESS_TOKEN        = '3271358660-e2D1lQU6CI8ZLIcKRRiKPMSdRFxtcBOQVODZ7N6'.freeze
ACCESS_TOKEN_SECRET = '68S2N3NCayoQY0LWQk46wNjJ7Sw8tb7pymAOmutakbaiX'.freeze
ADS_ACCOUNT         = '18ce54bgxky'.freeze

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
