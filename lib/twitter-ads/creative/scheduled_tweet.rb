# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

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
      property :media_keys, read_only: true
      property :scheduled_status, read_only: true
      property :tweet_id, read_only: true
      property :updated_at, type: :time, read_only: true
      property :user_id, read_only: true

      # writable
      property :as_user_id
      property :card_uri
      property :media_ids
      property :nullcast, type: :bool
      property :scheduled_at, type: :time
      property :text

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                            'accounts/%{account_id}/scheduled_tweets'.freeze # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" +
                 'accounts/%{account_id}/scheduled_tweets/%{id}'.freeze # @api private
      PREVIEW  = "/#{TwitterAds::API_VERSION}/" +
                 'accounts/%{account_id}/scheduled_tweets/preview/%{id}'.freeze # @api private

      def preview(account, opts = {})
        if @id
          resource = self.class::PREVIEW % { account_id: account.id, id: id }
          response = TwitterAds::Request.new(account.client, :get, resource, params: opts).perform
          response.body[:data]
        end
      end

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
