# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class PromotedTweet

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence
      include TwitterAds::Analytics

      attr_reader :account

      property :id, read_only: true
      property :approval_status, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true

      property :line_item_id
      property :tweet_ids
      property :paused, type: :bool

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/promoted_tweets' # @api private
      RESOURCE_STATS      = '/0/stats/accounts/%{account_id}/promoted_tweets' # @api private
      RESOURCE            = '/0/accounts/%{account_id}/promoted_tweets/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

      # Saves or updates the current object instance depending on the presence of `object.id`.
      #
      # @example
      #   object.save
      #
      # @return [self] Returns the instance refreshed from the API.
      #
      # Note: override to handle the inconsistency of the promoted tweet endpoint.
      #
      # @since 0.2.4
      def save
        params = to_params
        params[:tweet_ids] = *params.delete(:tweet_id) if params.key?(:tweet_id)
        if @id
          resource = self.class::RESOURCE % { account_id: account.id, id: id }
          response = Request.new(account.client, :put, resource, params: params).perform
          from_response(response.body[:data])
        else
          resource = self.class::RESOURCE_COLLECTION % { account_id: account.id }
          response = Request.new(account.client, :post, resource, params: params).perform
          from_response(response.body[:data].first)
        end
      end

    end

  end
end
