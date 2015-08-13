# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class LineItem

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence
    include TwitterAds::Analytics

    attr_reader :account

    property :id, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    property :name
    property :campaign_id
    property :advertiser_domain
    property :categories
    property :charge_by
    property :include_sentiment
    property :objective
    property :optimization
    property :paused, type: :bool
    property :primary_web_event_tag
    property :product_type
    property :placements
    property :bid_unit
    property :automatically_select_bid
    property :bid_amount_local_micro
    property :total_budget_amount_local_micro

    RESOURCE_COLLECTION = '/0/accounts/%{account_id}/line_items' # @api private
    RESOURCE_STATS      = '/0/stats/accounts/%{account_id}/line_items' # @api private
    RESOURCE            = '/0/accounts/%{account_id}/line_items/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end

  end
end
