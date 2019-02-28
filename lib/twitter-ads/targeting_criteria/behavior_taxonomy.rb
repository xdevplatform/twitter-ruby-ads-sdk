# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class BehaviorTaxonomy

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :id, read_only: true
    property :name, read_only: true
    property :parent_id, read_only: true
    property :created_at, read_only: true
    property :updated_at, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'targeting_criteria/behavior_taxonomies' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
