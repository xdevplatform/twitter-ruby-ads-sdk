# frozen_string_literal: true
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
      property :tweet_id
      property :paused, type: :bool

      RESOURCE_COLLECTION = '/1/accounts/%{account_id}/promoted_tweets'.freeze # @api private
      RESOURCE_STATS      = '/1/stats/accounts/%{account_id}'.freeze # @api private
      RESOURCE            = '/1/accounts/%{account_id}/promoted_tweets/%{id}'.freeze # @api private

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
      # Note: override to handle the inconsistency of the promoted tweet endpoint. (see REVAPI-5348)
      #
      # @since 0.2.4
      def save
        # manually check for missing params (due to API discrepancy)
        validate

        # convert to `tweet_ids` param
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

      private

      def validate
        details = []

        unless @line_item_id
          details << { code: 'MISSING_PARAMETER',
                       message: '"line_item_id" is a required parameter',
                       parameter: 'line_item_id' }
        end

        unless @tweet_id
          details << { code: 'MISSING_PARAMETER',
                       message: '"tweet_id" is a required parameter',
                       parameter: 'tweet_id' }
        end

        raise TwitterAds::ClientError.new(nil, details, 400) unless details.empty?
      end

    end

  end
end
