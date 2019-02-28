# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class Behavior

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :id, read_only: true
    property :name, read_only: true
    property :targeting_type, read_only: true
    property :targeting_value, read_only: true
    property :audience_code, read_only: true
    property :country_code, read_only: true
    property :partner_source, read_only: true
    property :targetable_type, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'targeting_criteria/behaviors' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
