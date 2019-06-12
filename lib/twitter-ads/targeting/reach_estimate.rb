# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module ReachEstimate

    class << self

      # Get a reach estimate for the specified line item details.
      #
      # @example
      #   TwitterAds::ReachEstimate.fetch(
      #     account,
      #     'PROMOTED_TWEETS',
      #     'WEBSITE_CLICKS',
      #     5500000,
      #     30000000,
      #     similar_to_followers_of_user: 2153688540,
      #     gender: 2
      #   )
      #
      # @param client [Client] The Client object instance.
      # @param product_type [String] The product type being targeted.
      # @param objective [String] The objective being targeted.
      # @param campaign_daily_budget_amount_local_micro [Long] Daily budget in micros.
      # @param opts [Hash] A Hash of extended options.
      #
      # @option opts [Long] :bid_amount_local_micro Bid amount in local currency micros.
      # @option opts [String] :bid_type The bidding mechanism.
      # @option opts [String] :currency ISO-4217 Currency code for bid amount.
      # @option opts [String] :followers_of_users Comma-separated user IDs.
      # @option opts [String] :similar_to_followers_of_users Comma-separated user IDs.
      # @option opts [String] :locations Comma-separated location IDs.
      # @option opts [String] :interests Comma-seaprated interest IDs.
      # @option opts [String] :gender Gender identifier.
      # @option opts [String] :platforms Comma-separated platform IDs.
      # @option opts [String] :tailored_audiences Comma-separated tailored audience IDs.
      # @option opts [String] :tailored_audiences_expanded Comma-separated tailoerd audience IDs.
      # @option opts [String] :languages Comma-separated language IDs.
      # @option opts [String] :platform_versions Comma-separated platform version IDs.
      # @option opts [String] :devices Comma-separated device IDs.
      # @option opts [String] :behaviors Comma-separated behavior IDs.
      # @option opts [String] :behaviors_expanded Comma-separated behaviors IDs.
      # @option opts [String] :campaign engagement Campaign ID for Tweet Engager Retargeting.
      # @option opts [String] :user_engagement Promoted User ID for Tweet Engager Retargeting.
      # @option opts [String] :engagement_type engagement type for Tweet Engager Retargeting.
      # @option opts [String] :network_operators Network operators to target
      # @option opts [String] :app_store_categories App store categories to target.
      # @option opts [String] :app_store_categories_expanded App store categories with lookalikes.
      #
      # @return [Hash] A hash containing count and infinite_bid_count.
      #
      # @since 1.0.0
      # @see https://developer.twitter.com/en/docs/ads/campaign-management/api-reference/reach-estimate
      def fetch(account, product_type, objective, campaign_daily_budget,
                opts = {})
        resource = "/#{TwitterAds::API_VERSION}/accounts/#{account.id}/reach_estimate"
        params = {
          product_type: product_type,
          objective: objective,
          campaign_daily_budget_amount_local_micro: campaign_daily_budget
        }.merge!(opts)

        # The response value count is "bid sensitive", we default to bid_type=AUTO here to preserve
        # expected behavior despite an API change that occurred in December 2015.
        unless params.keys.include?(:bid_type) || params.keys.include?(:bid_amount_local_micro)
          params = { bid_type: 'AUTO' }.merge!(params)
        end

        response = TwitterAds::Request.new(account.client, :get,
                                           resource, params: params).perform
        response.body[:data]
      end

    end

  end
end
