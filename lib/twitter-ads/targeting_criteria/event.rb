# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class Event

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :id, read_only: true
    property :name, read_only: true
    property :reach, read_only: true
    property :start_time, read_only: true
    property :end_time, read_only: true
    property :top_users, read_only: true
    property :top_tweets, read_only: true
    property :top_hashtags, read_only: true
    property :country_code, read_only: true
    property :is_global, read_only: true
    property :category, read_only: true
    property :gender_breakdown_percentage, read_only: true
    property :device_breakdown_percentage, read_only: true
    property :country_breakdown_percentage, read_only: true
    property :targeting_value, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'targeting_criteria/events' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
