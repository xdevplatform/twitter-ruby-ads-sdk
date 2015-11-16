# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class TargetingCriteria

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence

    attr_reader :account

    property :id, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    property :name
    property :line_item_id
    property :targeting_type
    property :targeting_value
    property :tailored_audience_expansion, type: :bool
    property :tailored_audience_type

    RESOURCE_COLLECTION = '/0/accounts/%{account_id}/targeting_criteria' # @api private
    RESOURCE            = '/0/accounts/%{account_id}/targeting_criteria/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
