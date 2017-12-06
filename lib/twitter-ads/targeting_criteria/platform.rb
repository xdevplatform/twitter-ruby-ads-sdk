# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class Platform

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :name, read_only: true
    property :targeting_type, read_only: true
    property :targeting_value, read_only: true
    property :localized_name, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                          'targeting_criteria/platforms'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
