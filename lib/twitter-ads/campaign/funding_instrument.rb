# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class FundingInstrument

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Analytics

    attr_reader :account

    property :id, read_only: true
    property :name, read_only: true
    property :cancelled, read_only: true
    property :credit_limit_local_micro, read_only: true
    property :currency, read_only: true
    property :description, read_only: true
    property :funded_amount_local_micro, read_only: true
    property :type, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    RESOURCE_COLLECTION = '/1/accounts/%{account_id}/funding_instruments'.freeze # @api private
    RESOURCE = '/1/accounts/%{account_id}/funding_instruments/%{id}'.freeze # @api private
    RESOURCE_STATS      = '/1/stats/accounts/%{account_id}'.freeze # @api private
    RESOURCE_ASYNC_STATS = '/1/stats/jobs/accounts/%{account_id}'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end

  end
end
