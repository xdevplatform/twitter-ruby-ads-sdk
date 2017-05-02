# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.
# Author Bob, Nugit

module TwitterAds
  class OrganicTweet

    include TwitterAds::Analytics

    RESOURCE_STATS       = '/1/stats/accounts/%{account_id}'.freeze # @api private
    RESOURCE_ASYNC_STATS = '/1/stats/jobs/accounts/%{account_id}'.freeze # @api private
  end
end
