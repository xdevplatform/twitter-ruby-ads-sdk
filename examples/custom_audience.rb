# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'digest'
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

# create a new placeholder custom audience
audience =
  TwitterAds::CustomAudience.create(account, 'Test TA')

# sample user
# all values musth be sha256 hashede except 'partner_user_id'
email_hash = Digest::SHA256.hexdigest 'test-email@test.com'

# create payload
user = [{
  operation_type: 'Update',
  params: {
    users: [{
      email: [
        email_hash
      ]
    }]
  }
}]

# update the custom audience
success_count, total_count = audience.users(user)
print "Successfully added #{total_count} users" if success_count == total_count
