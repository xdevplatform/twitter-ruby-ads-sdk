# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

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
    property :paused, type: :bool
    property :currency
    property :standard_delivery
    property :daily_budget_amount_local_micro
    property :total_budget_amount_local_micro

    # sdk only
    property :to_delete, type: :bool

    RESOURCE_COLLECTION = '/1/accounts/%{account_id}/campaigns'.freeze # @api private
    RESOURCE_STATS      = '/1/stats/accounts/%{account_id}'.freeze # @api private
    RESOURCE_ASYNC_STATS = '/1/stats/jobs/accounts/%{account_id}'.freeze # @api private
    RESOURCE_BATCH      = '/1/batch/accounts/%{account_id}/campaigns'.freeze # @api private
    RESOURCE            = '/1/accounts/%{account_id}/campaigns/%{id}'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end

  end
end
