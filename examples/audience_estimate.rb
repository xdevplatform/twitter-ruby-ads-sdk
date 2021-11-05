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

# load up the account instance
account = client.accounts(ADS_ACCOUNT)

# targeting criteria params
params = {
  targeting_criteria: [
    {
      targeting_type: 'LOCATION',
      targeting_value: '96683cc9126741d1'
    },
    {
      targeting_type: 'BROAD_KEYWORD',
      targeting_value: 'cats'
    },
    {
      targeting_type: 'SIMILAR_TO_FOLLOWERS_OF_USER',
      targeting_value: '14230524'
    },
    {
      targeting_type: 'SIMILAR_TO_FOLLOWERS_OF_USER',
      targeting_value: '90420314'
    }
  ]
}

audience_estimate = TwitterAds::AudienceEstimate.fetch(account, params)
puts audience_estimate
