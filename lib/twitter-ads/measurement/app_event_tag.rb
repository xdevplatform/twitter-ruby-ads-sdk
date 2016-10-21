# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class AppEventTag

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence

    property :id, read_only: true
    property :name
    property :account_id
    property :app_store_identifier
    property :os_type
    property :status, read_only: true
    property :conversion_type
    property :provider_app_event_id
    property :provider_app_event_name
    property :deleted, read_only: true
    property :post_view_attribution_window
    property :post_engagement_attribution_window

    RESOURCE_COLLECTION = '/1/accounts/%{account_id}/app_event_tags'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
