# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class WebEventTag

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence

    property :id, read_only: true
    property :name
    property :retargeting_enabled, type: :bool
    property :status, read_only: true
    property :type
    property :view_through_window
    property :deleted, read_only: true
    property :embed_code, read_only: true
    property :click_window

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/web_event_tags' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
