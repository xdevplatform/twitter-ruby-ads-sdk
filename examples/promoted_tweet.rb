# Copyright (C) 2015 Twitter, Inc.

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

# load up the account instance
account = client.accounts(ADS_ACCOUNT)

# resource url for tweet creation
resource = "/0/accounts/#{account.id}/tweet"

# create request for a simple nullcasted tweet
tweet_params = { status: 'There can be only one...' }
tweet = TwitterAds::Request.new(client, :post, resource, params: tweet_params).perform
tweet[:data][:id]

# create request for a nullcasted tweet with a website card
website_card = TwitterAds::Creative::WebsiteCard.all(account).first
tweet_params = { status: "Fine. There can be two. #{website_card.preview_url}" }
tweet = TwitterAds::Request.new(client, :post, resource, params: tweet_params).perform
tweet[:data][:id]
