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
      PREVIEW  = "/#{TwitterAds::API_VERSION}/" \
               'accounts/%{account_id}/draft_tweets/preview/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

      def preview(account: @account, draft_tweet_id: nil)
        if !draft_tweet_id.nil?
          resource = self.class::PREVIEW % { account_id: account.id, id: draft_tweet_id }
        elsif @id
          resource = self.class::PREVIEW % { account_id: account.id, id: id }
        else
          raise ArgumentError.new(
            "object has no 'draft_tweet_id' to preview")
        end
        response = TwitterAds::Request.new(account.client, :post, resource).perform
        response.body
      end

    end
  end
end
