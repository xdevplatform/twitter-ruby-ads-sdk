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

# load up the account instance
account = client.accounts(ADS_ACCOUNT)

# preview an existing tweet
TwitterAds::Tweet.preview(account, id: 634798319504617472)

# preview a new tweet
TwitterAds::Tweet.preview(account, text: 'Moose bites can be deadly')

# preview a new tweet with embedded card
card = TwitterAds::Creative::WebsiteCard.all(account).first
TwitterAds::Tweet.preview(account, text: 'Moose PSA Website', card_id: card.id)

# preview a new tweet an image
TwitterAds::Tweet.preview(
  account, text: 'Public Moosenemy #1', media_ids: 634458428836962304)

# preview a new tweet multiple images (up to 4)
images = [634458428836962305, 634458428836962306, 634458428836962307, 634458428836962308]
TwitterAds::Tweet.preview(
  account, text: 'Here are some moose pictures. Beware.', media_ids: images)
