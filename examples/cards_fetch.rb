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

# retrieve a tweet
tweet_id = '859263438396153856' # use one of your own tweets with card_uri in response
resource = "/1.1/statuses/show/#{tweet_id}.json"
domain = 'https://api.twitter.com'
params   = { include_card_uri: 'true' }
response = TwitterAds::Request.new(client, :get, resource, domain: domain, params: params).perform
uri = response.body[:card_uri] # 54ytn

# fetch by card_uri
cf = TwitterAds::Creative::CardsFetch.new(account)
card = cf.load(account, uri).first
puts card.card_type # IMAGE_APP_DOWNLOAD
puts card.id # '54ytn'

# fetch by card_id
cf = TwitterAds::Creative::CardsFetch.new(account)
same_card = cf.load(account, nil, card.id)
puts same_card.card_type # IMAGE_APP_DOWNLOAD
puts same_card.card_uri # 'card://942628629552406533'
