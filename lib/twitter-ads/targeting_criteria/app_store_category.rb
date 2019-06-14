# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class AppStoreCategory

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :name, read_only: true
    property :os_type, read_only: true
    property :targeting_type, read_only: true
    property :targeting_value, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'targeting_criteria/app_store_categories' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
