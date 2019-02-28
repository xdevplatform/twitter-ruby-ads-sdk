# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class AppEventTag

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence

    property :id, read_only: true
    property :account_id
    property :app_store_identifier
    property :os_type
    property :conversion_type
    property :provider_app_event_id
    property :provider_app_event_name
    property :deleted, read_only: true
    property :post_view_attribution_window
    property :post_engagement_attribution_window

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/app_event_tags' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
