# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class TvMarket

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :id, read_only: true
    property :name, read_only: true
    property :locale, read_only: true
    property :country_code, read_only: true

    RESOURCE_COLLECTION = '/0/targeting_criteria/tv_markets' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
