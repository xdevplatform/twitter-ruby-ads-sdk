# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class DraftTweet

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      # read-only
      property :id, read_only: true
      property :id_str, read_only: true
      property :media_keys, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :user_id, read_only: true
      # writable
      property :as_user_id
      property :card_uri
      property :media_ids
      property :nullcast, type: :bool
      property :text

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                            'accounts/%{account_id}/draft_tweets' # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" \
                 'accounts/%{account_id}/draft_tweets/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end
  end
end
