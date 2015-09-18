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

# load up the account instance, campaign and line item
account   = client.accounts(ADS_ACCOUNT)
campaign  = account.campaigns.first
line_item = account.line_items(nil, params: { campaign_id: campaign.id }).first

# resource url for tweet creation
resource = "/0/accounts/#{account.id}/tweet"

# create request for a simple nullcasted tweet
tweet_params = { status: 'There can be only one...' }
tweet1 = TwitterAds::Request.new(client, :post, resource, params: tweet_params).perform

# promote the tweet using our line item
promoted_tweet = TwitterAds::Creative::PromotedTweet.new(account)
promoted_tweet.line_item_id = line_item.id
promoted_tweet.tweet_id     = tweet1.body[:data][:id]
promoted_tweet.save

# create request for a nullcasted tweet with a website card
website_card = TwitterAds::Creative::WebsiteCard.all(account).first
tweet_params = { status: "Fine. There can be two. #{website_card.preview_url}" }
tweet2 = TwitterAds::Request.new(client, :post, resource, params: tweet_params).perform

# promote the tweet using our line item
promoted_tweet = TwitterAds::Creative::PromotedTweet.new(account)
promoted_tweet.line_item_id = line_item.id
promoted_tweet.tweet_id     = tweet2.body[:data][:id]
promoted_tweet.save
