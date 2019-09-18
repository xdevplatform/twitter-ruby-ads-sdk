# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class Tweets

      include TwitterAds::DSL
      include TwitterAds::Resource

      attr_reader :account

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                            'accounts/%{account_id}/tweets' # @api private

      # Retrieve Tweet details for the account's full promotable user (default)
      # or the user specified in the user_id parameter.
      #
      # @example
      #   tweets = TwitterAds::Creative::Tweets.all(
      #     account,
      #     tweet_type: 'PUBLISHED',
      #     tweet_ids: %w(1122911801354510336 1102836745790316550),
      #     timeline_type: 'ORGANIC'
      #   )
      #
      # @param account [Account] The Account object instance.
      # @param tweet_type [String] The Tweet type for the specified tweet_ids.
      # @option opts [Int] :count The number of records to try and retrieve per distinct request.
      # @option opts [String] :cursor A cursor to get the next page of results.
      # @option opts [String] :timeline_type The granularity to use (default: NULLCAST).
      # @option opts [Boolean] :trim_user Whether to exclude the user object
      #   in the Tweet response (default: false).
      # @option opts [Array] :tweet_ids A collection of tweet IDs to be fetched.
      # @option opts [Long] :user_id The user ID to scope Tweets to.
      #
      # @return A list of tweets details.
      #
      # @see https://developer.twitter.com/en/docs/ads/creatives/api-reference/tweets#get-accounts-account-id-tweets
      # @since 6.0.0

      def self.all(account, opts = {})
        params = TwitterAds::Utils.flatten_params(opts)
        resource = self::RESOURCE_COLLECTION % { account_id: account.id }
        request = Request.new(account.client, :get, resource, params: params)
        Cursor.new(nil, request, init_with: [account])
      end

    end
  end
end
