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

tailored_audience_id = '36n4f'

# fetch all permissions
permissions = TwitterAds::TailoredAudiencePermission.all(account, tailored_audience_id)

permissions.each { |data|
  p data.id
  p data.permission_level
  p data.granted_account_id
}

# create instance
permission = TwitterAds::TailoredAudiencePermission.new(account)

# set required params
permission.tailored_audience_id = tailored_audience_id
permission.granted_account_id = '18ce54uvbwu'
permission.permission_level = PermissionLevel::READ_ONLY

# set permission
response = permission.save

# delete permission
permission.id = response.id
permission.delete!
