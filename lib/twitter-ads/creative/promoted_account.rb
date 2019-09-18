# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class PromotedAccount < Analytics

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :approval_status, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true

      property :line_item_id
      property :user_id
      property :paused, type: :bool

      RESOURCE_COLLECTION  = "/#{TwitterAds::API_VERSION}/" \
                             'accounts/%{account_id}/promoted_accounts' # @api private
      RESOURCE             = "/#{TwitterAds::API_VERSION}/" \
                             'accounts/%{account_id}/promoted_accounts/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
