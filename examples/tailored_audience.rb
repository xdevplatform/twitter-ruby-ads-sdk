# Copyright (C) 2015 Twitter, Inc.

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

# load up the account instance
account = client.accounts(ADS_ACCOUNT)

# create a new tailored audience
audience =
  TwitterAds::TailoredAudience.create(account, '/path/to/file', 'my list', TAListTypes::Email)

# check the processing status
audience.status

# update the tailored audience
audience.update('/path/to/file', 'TWITTER_ID', TAOperations::REMOVE)
audience.update('/path/to/file', 'PHONE_NUMBER', TAOperations::ADD)

# delete the tailored audience
audience.delete!

# add users to the account's global opt-out list
TwitterAds::TailoredAudience.opt_out(account, '/path/to/file', TAListTypes::HANDLE)
