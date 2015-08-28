# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module ReachEstimate

    class << self

      # Get a reach estimate for the specified line item details.
      #
      # @example
      #   TwitterAds::ReachEstimate.fetch(
      #     account, "PROMOTED_TWEETS", "WEBSITE_CLICKS", 12,
      #     similar_to_followers_of_user: "12", gender: "2")
      #
      # @param client [Client] The Client object instance.
      # @param account [Account] The Ads Account instance for this request.
      # @param product_type [String] The product type being targeted.
      # @param objective [String] The objective being targeted.
      # @param user_id [Long] The ID of the user whose content will be promoted.
      # @param opts [Hash] A Hash of extended options.
      #
      # @option opts [String] :bid_type The bidding mechanism.
      # @option opts [Long] :bid_amount_local_micro Bid amount in local currency micros.
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
      #
      # @return [Hash] A hash containing count and infinite_bid_count.
      #
      # @since 0.3.0
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/reach_estimate
      def fetch(account, product_type, objective, user_id, opts = {})
        resource = "/0/accounts/#{account.id}/reach_estimate"
        params   = { product_type: product_type, objective: objective,
                     user_id: user_id }
        response = TwitterAds::Request.new(
          account.client, :get, resource, params: params.merge(opts)).perform
        response.body[:data]
      end

    end

  end
end
