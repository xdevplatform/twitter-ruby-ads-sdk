# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class IABCategory

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :name, read_only: true
    property :parent_id, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/iab_categories" # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
