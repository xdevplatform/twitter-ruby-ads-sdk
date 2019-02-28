# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class TVMarket

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :id, read_only: true
    property :name, read_only: true
    property :locale, read_only: true
    property :country_code, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'targeting_criteria/tv_markets' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
