# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Placement

    ALL_ON_TWITTER    = 'ALL_ON_TWITTER'
    TWITTER_SEARCH    = 'TWITTER_SEARCH'
    TWITTER_TIMELINE  = 'TWITTER_TIMELINE'
    PUBLISHER_NETWORK = 'PUBLISHER_NETWORK'

    class << self

      # Helper method to return a list a valid placement combinations by Product.
      #
      # @example
      #   Placement.valid_combinations(Product::PROMOTED_TWEETS)
      #
      # @param product_type [Product] The enum value for the Product type being targeted.
      #
      # @return [Array] An array of valid placement combinations.
      #
      # @since 0.1.0
      # @see https://dev.twitter.com/ads/reference/get/line_items/placements
      def valid_combinations(client, product_type)
        resource = '/0/line_items/placements'
        params   = { product_type: product_type }
        response = TwitterAds::Request.new(client, :get, resource, params: params).perform
        response.body[:data][0][:placements]
      end

    end

  end
end
