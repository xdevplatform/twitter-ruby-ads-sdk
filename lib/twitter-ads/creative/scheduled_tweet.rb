# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class ScheduledTweet

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      # read-only
      property :completed_at, type: :time, read_only: true
      property :created_at, type: :time, read_only: true
      property :id, read_only: true
      property :id_str, read_only: true
      property :scheduled_status, read_only: true
      property :tweet_id, read_only: true
      property :updated_at, type: :time, read_only: true
      property :user_id, read_only: true

      # writable
      property :as_user_id
      property :card_uri
      property :media_keys
      property :nullcast, type: :bool
      property :scheduled_at, type: :time
      property :text

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                            'accounts/%{account_id}/scheduled_tweets' # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" \
                 'accounts/%{account_id}/scheduled_tweets/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
