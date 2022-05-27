# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.
require 'twitter-ads'

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

# create the card
name = 'video website card'
components = [
  {
    type: 'MEDIA',
    media_key: '13_794652834998325248'
  },
  {
    type: 'DETAILS',
    title: 'Twitter',
    destination: {
      type: 'WEBSITE',
      url: 'http://twitter.com/'
    }
  }
]

vwc = TwitterAds::Creative::Cards.new(account)
vwc.name = name
vwc.components = components
vwc.save
vwc.name = 'vwc - ruby sdk'
vwc.save
puts vwc.name # vwc - ruby sdk

# fetch all
# card = TwitterAds::Creative::Cards.all(account, card_ids: '1508693734346485761').first

# fetch by card-id
# card = TwitterAds::Creative::Cards.load(account, '1508693734346485761')

# get user_id for as_user_id parameter
user_id = TwitterRestApi::UserIdLookup.load(account, screen_name: 'your_screen_name').id

# create a draft tweet using this new card
tweet = TwitterAds::Creative::DraftTweet.new(account)
tweet.text = 'Created from SDK'
tweet.as_user_id = user_id
tweet.card_uri = vwc.card_uri
tweet.save
