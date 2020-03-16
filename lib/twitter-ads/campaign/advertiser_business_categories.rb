# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class AdvertiserBusinessCategories

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :name, read_only: true
    property :iab_categories, read_only: true

    # @api private
    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/advertiser_business_categories"

    def initialize(account)
      @account = account
      self
    end
  end
end
