# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class Campaign

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence
    include TwitterAds::Analytics
    include TwitterAds::Batch

    attr_reader :account

    property :id, read_only: true
    property :reasons_not_servable, read_only: true
    property :servable, read_only: true
    property :deleted, type: :bool, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true

    property :name
    property :funding_instrument_id
    property :end_time, type: :time
    property :start_time, type: :time
    property :entity_status
    property :currency
    property :standard_delivery
    property :daily_budget_amount_local_micro
    property :total_budget_amount_local_micro

    # sdk only
    property :to_delete, type: :bool

    RESOURCE_COLLECTION  = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/campaigns' # @api private
    RESOURCE_BATCH       = "/#{TwitterAds::API_VERSION}/" \
                           'batch/accounts/%{account_id}/campaigns' # @api private
    RESOURCE             = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/campaigns/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end

  end
end
