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

# get user_id for as_user_id parameter
user_id = TwitterRestApi::UserIdLookup.load(account, screen_name: 'your_twitter_handle_name').id

# fetch draft tweets from a given account
tweets = TwitterAds::Creative::DraftTweet.all(account)
tweets.each { |tweet|
  p tweet.id_str
  p tweet.text
}

# create a new draft tweet
draft_tweet = TwitterAds::Creative::DraftTweet.new(account)
draft_tweet.text = 'draft tweet - new'
draft_tweet.as_user_id = user_id
draft_tweet.save
p draft_tweet.id_str
p draft_tweet.text

# fetch single draft tweet metadata
tweet_id = draft_tweet.id_str
draft_tweet = TwitterAds::Creative::DraftTweet.load(account, tweet_id)
p draft_tweet.id_str
p draft_tweet.text

# update (PUT) metadata
draft_tweet.text = 'draft tweet - update'
draft_tweet = draft_tweet.save
p draft_tweet.id_str
p draft_tweet.text

# preview draft tweet of current instance (send notification)
draft_tweet.preview
# or, specify any draft_tweet_id
# draft_tweet.preview(draft_tweet_id: '1142048306194862080')

# create a nullcasted tweet using draft tweet metadata
tweet = TwitterAds::Tweet.create(account, text: draft_tweet.text, as_user_id: user_id)
p tweet

# delete draft tweet
# draft_tweet.delete!
