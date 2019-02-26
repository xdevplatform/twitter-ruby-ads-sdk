# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class LineItem

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence
    include TwitterAds::Analytics
    include TwitterAds::Batch

    attr_reader :account

    property :id, read_only: true
    property :deleted, type: :bool, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true

    property :name
    property :campaign_id
    property :advertiser_domain
    property :categories
    property :charge_by
    property :include_sentiment
    property :objective
    property :optimization
    property :entity_status
    property :primary_web_event_tag
    property :product_type
    property :placements
    property :bid_unit
    property :automatically_select_bid
    property :bid_amount_local_micro
    property :total_budget_amount_local_micro
    property :target_cpa_local_micro

    # beta (not yet generally available)
    property :advertiser_user_id
    property :bid_type
    property :tracking_tags
    property :lookalike_expansion

    # sdk only
    property :to_delete, type: :bool

    RESOURCE_COLLECTION  = "/#{TwitterAds::API_VERSION}/" +
                           'accounts/%{account_id}/line_items'.freeze # @api private
    RESOURCE_STATS       = "/#{TwitterAds::API_VERSION}/" +
                           'stats/accounts/%{account_id}'.freeze # @api private
    RESOURCE_ASYNC_STATS = "/#{TwitterAds::API_VERSION}/" +
                           'stats/jobs/accounts/%{account_id}'.freeze # @api private
    RESOURCE_BATCH       = "/#{TwitterAds::API_VERSION}/" +
                           'batch/accounts/%{account_id}/line_items'.freeze # @api private
    RESOURCE             = "/#{TwitterAds::API_VERSION}/" +
                           'accounts/%{account_id}/line_items/%{id}'.freeze # @api private
    RESOURCE_PLACEMENTS  = "/#{TwitterAds::API_VERSION}/" +
                           'line_items/placements'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end

    class << self

      # Helper method to return a list a valid placement combinations by Product.
      #
      # @example
      #   LineItem.placements(Product::PROMOTED_TWEETS)
      #
      # @param product_type [Product] The enum value for the Product type being targeted.
      #
      # @return [Array] An array of valid placement combinations.
      #
      # @since 0.3.2
      # @see https://dev.twitter.com/ads/reference/get/line_items/placements
      def placements(client, product_type = nil)
        params   = { product_type: product_type } if product_type
        response = TwitterAds::Request.new(client, :get,
                                           RESOURCE_PLACEMENTS, params: params).perform
        response.body[:data][0][:placements]
      end

    end

    # Returns a collection of targeting criteria available to the current line item.
    #
    # @param id [String] The TargetingCriteria ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @since 0.3.1
    #
    # @return A Cursor or object instance.
    def targeting_criteria(id = nil, opts = {})
      id ? TargetingCriteria.load(account, id, opts) : TargetingCriteria.all(account, @id, opts)
    end

  end
end
