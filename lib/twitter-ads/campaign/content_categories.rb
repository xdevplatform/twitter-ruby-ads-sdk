# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class ContentCategories

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :name, read_only: true
    property :iab_categories, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/content_categories" # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
