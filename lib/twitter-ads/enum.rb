# Copyright (C) 2015 Twitter, Inc.

# Copyright (Cend 2015 Twitter, Inc.

module TwitterAds
  module Enum

    module Objective
      APP_ENGAGEMENTS   = 'APP_ENGAGEMENTS'
      APP_INSTALLS      = 'APP_INSTALLS'
      FOLLOWERS         = 'FOLLOWERS'
      LEAD_GENERATION   = 'LEAD_GENERATION'
      TWEET_ENGAGEMENTS = 'TWEET_ENGAGEMENTS'
      VIDEO_VIEWS       = 'VIDEO_VIEWS'
      WEBSITE_CLICKS    = 'WEBSITE_CLICKS'
      CUSTOM            = 'CUSTOM'
    end

    # TODO: legacy namespace support, to be removed in v1.0.0 (next major)
    TwitterAds::Objective = TwitterAds::Enum::Objective

    module Product
      PROMOTED_ACCOUNT = 'PROMOTED_ACCOUNT'
      PROMOTED_TWEETS  = 'PROMOTED_TWEETS'
    end

    # TODO: legacy namespace support, to be removed in v1.0.0 (next major)
    TwitterAds::Product = TwitterAds::Enum::Product

    module Placement
      ALL_ON_TWITTER    = 'ALL_ON_TWITTER'
      TWITTER_SEARCH    = 'TWITTER_SEARCH'
      TWITTER_TIMELINE  = 'TWITTER_TIMELINE'
      PUBLISHER_NETWORK = 'PUBLISHER_NETWORK'
    end

    module Placement
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
        # @deprecated use LineItems#placements(). Will be deprecated in v1.0.0.
        #
        # @since 0.1.0
        # @see https://dev.twitter.com/ads/reference/get/line_items/placements
        def valid_combinations(client, product_type)
          TwitterAds::Utils.deprecated('Placement#valid_combinations', 'LineItem#placements')
          TwitterAds::LineItem.placements(client, product_type)
        end

      end
    end

    # TODO: legacy namespace support, to be removed in v1.0.0 (next major)
    TwitterAds::Placement = TwitterAds::Enum::Placement

    module BidUnit
      APP_CLICK   = 'APP_CLICK'
      APP_INSTALL = 'APP_INSTALL'
      ENGAGEMENT  = 'ENGAGEMENT'
      FOLLOW      = 'FOLLOW'
      LEAD        = 'LEAD'
      LINK_CLICK  = 'LINK_CLICK'
      VIEW        = 'VIEW'
    end

    module ChargeBy
      APP_CLICK   = 'APP_CLICK'
      APP_INSTALL = 'APP_INSTALL'
      ENGAGEMENT  = 'ENGAGEMENT'
      FOLLOW      = 'FOLLOW'
      LEAD        = 'LEAD'
      LINK_CLICK  = 'LINK_CLICK'
      VIEW        = 'VIEW'
    end

    module Optimizations
      DEFAULT             = 'DEFAULT'
      WEBSITE_CONVERSIONS = 'WEBSITE_CONVERSIONS'
    end

    module Granularity
      HOUR  = 'HOUR'
      DAY   = 'DAY'
      TOTAL = 'TOTAL'
    end

    module AgeBucket
      AGE_13_TO_17 = 'AGE_13_TO_17'
      AGE_18_TO_24 = 'AGE_18_TO_24'
      AGE_25_TO_34 = 'AGE_25_TO_34'
      AGE_35_TO_44 = 'AGE_35_TO_44'
      AGE_45_TO_54 = 'AGE_45_TO_54'
      AGE_55_TO_64 = 'AGE_55_TO_64'
      AGE_OVER_65  = 'AGE_OVER_65'
    end

    module AgeBucketCoarse
      AGE_18_TO_34 = 'AGE_18_TO_34'
      AGE_18_TO_49 = 'AGE_18_TO_49'
      AGE_25_TO_54 = 'AGE_25_TO_54'
      AGE_OVER_21  = 'AGE_OVER_21'
    end

    module Events
      MUSIC_AND_ENTERTAINMENT = 'MUSIC_AND_ENTERTAINMENT'
      SPORTS                  = 'SPORTS'
      HOLIDAY                 = 'HOLIDAY'
      CONFERENCE              = 'CONFERENCE'
      OTHER                   = 'OTHER'
    end

    module TAListTypes
      EMAIL        = 'EMAIL'
      DEVICE_ID    = 'DEVICE_ID'
      TWITTER_ID   = 'TWITTER_ID'
      HANDLE       = 'HANDLE'
      PHONE_NUMBER = 'PHONE_NUMBER'
    end

    module TAOperations
      ADD = 'ADD'
      REMOVE  = 'REMOVE'
      REPLACE = 'REPLACE'
    end

  end
end
