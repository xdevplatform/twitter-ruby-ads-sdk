# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class PromotableUser

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :promotable_user_type, read_only: true
    property :user_id, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/promotable_users' # @api private
    RESOURCE            = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/promotable_users/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end

  end
end
