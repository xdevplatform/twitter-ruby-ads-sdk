# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.
# Author Bob, Nugit

module TwitterAds
  class OrganicTweet

    include TwitterAds::Analytics

    RESOURCE_STATS       = "/#{TwitterAds::API_VERSION}/" \
                           'stats/accounts/%{account_id}' # @api private
    RESOURCE_ASYNC_STATS = "/#{TwitterAds::API_VERSION}/" \
                           'stats/jobs/accounts/%{account_id}' # @api private
  end
end
