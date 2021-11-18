# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

# Copyright (Cend 2015 Twitter, Inc.

module TwitterAds
  module Enum

    module Objective
      APP_ENGAGEMENTS     = 'APP_ENGAGEMENTS'
      APP_INSTALLS        = 'APP_INSTALLS'
      ENGAGEMENTS         = 'ENGAGEMENTS'
      FOLLOWERS           = 'FOLLOWERS'
      PREROLL_VIEWS       = 'PREROLL_VIEWS'
      REACH               = 'REACH'
      VIDEO_VIEWS         = 'VIDEO_VIEWS'
      WEBSITE_CLICKS      = 'WEBSITE_CLICKS'
    end

    module Product
      PROMOTED_ACCOUNT = 'PROMOTED_ACCOUNT'
      PROMOTED_TWEETS  = 'PROMOTED_TWEETS'
    end

    module Placement
      ALL_ON_TWITTER     = 'ALL_ON_TWITTER'
      TWITTER_SEARCH     = 'TWITTER_SEARCH'
      TWITTER_TIMELINE   = 'TWITTER_TIMELINE'
      PUBLISHER_NETWORK  = 'PUBLISHER_NETWORK'
      TAP_FULL           = 'TAP_FULL'
      TAP_FULL_LANDSCAPE = 'TAP_FULL_LANDSCAPE'
      TAP_BANNER         = 'TAP_BANNER'
      TAP_NATIVE         = 'TAP_NATIVE'
      TAP_MRECT          = 'TAP_MRECT'
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
          TwitterAds::Utils.deprecated(
            'Placement#valid_combinations', replacement: 'LineItem#placements')
          TwitterAds::LineItem.placements(client, product_type)
        end

      end
    end

    module Goal
      APP_CLICKS = 'APP_CLICKS'
      APP_INSTALLS = 'APP_INSTALLS'
      ENGAGEMENT = 'ENGAGEMENT'
      FOLLOWERS = 'FOLLOWERS'
      LINK_CLICKS = 'LINK_CLICKS'
      MAX_REACH = 'MAX_REACH'
      PREROLL = 'PREROLL'
      PREROLL_STARTS = 'PREROLL_STARTS'
      REACH_WITH_ENGAGEMENT = 'REACH_WITH_ENGAGEMENT'
      VIDEO_VIEW = 'VIDEO_VIEW'
      VIEW_3S_100PCT = 'VIEW_3S_100PCT'
      VIEW_6S = 'VIEW_6S'
      VIEW_15S = 'VIEW_15S'
      WEBSITE_CONVERSIONS = 'WEBSITE_CONVERSIONS'
    end

    module BidStrategy
      MAX    = 'MAX'
      AUTO   = 'AUTO'
      TARGET = 'TARGET'
    end

    module PayBy
      APP_CLICK = 'APP_CLICK'
      IMPRESSION = 'IMPRESSION'
    end

    module MetricGroup
      ENGAGEMENT        = 'ENGAGEMENT'
      WEB_CONVERSION    = 'WEB_CONVERSION'
      MOBILE_CONVERSION = 'MOBILE_CONVERSION'
      MEDIA             = 'MEDIA'
      VIDEO             = 'VIDEO'
      BILLING           = 'BILLING'
      LIFE_TIME_VALUE_MOBILE_CONVERSION = 'LIFE_TIME_VALUE_MOBILE_CONVERSION'
    end

    module JobStatus
      QUEUED      = 'QUEUED'
      PROCESSING  = 'PROCESSING'
      UPLOADING   = 'UPLOADING'
      SUCCESS     = 'SUCCESS'
      FAILED      = 'FAILED'
    end

    module Entity
      ACCOUNT            = 'ACCOUNT'
      FUNDING_INSTRUMENT = 'FUNDING_INSTRUMENT'
      CAMPAIGN           = 'CAMPAIGN'
      LINE_ITEM          = 'LINE_ITEM'
      PROMOTED_ACCOUNT   = 'PROMOTED_ACCOUNT'
      PROMOTED_TWEET     = 'PROMOTED_TWEET'
      ORGANIC_TWEET      = 'ORGANIC_TWEET'
      MEDIA_CREATIVE     = 'MEDIA_CREATIVE'
    end

    module EntityStatus
      ACTIVE = 'ACTIVE'
      DRAFT  = 'DRAFT'
      PAUSED = 'PAUSED'
    end

    module CreativeType
      BANNER                        = 'BANNER'
      INTERSTITIAL                  = 'INTERSTITIAL'
      PREROLL                       = 'PREROLL'
      VAST_PREROLL                  = 'VAST_PREROLL'
      MEDIUM_RECTANGLE              = 'MEDIUM_RECTANGLE'
      BANNER_TABLET                 = 'BANNER_TABLET'
      INTERSTITIAL_LANDSCAPE        = 'INTERSTITIAL_LANDSCAPE'
      INTERSTITIAL_TABLET           = 'INTERSTITIAL_TABLET'
      INTERSTITIAL_LANDSCAPE_TABLET = 'INTERSTITIAL_LANDSCAPE_TABLET'
    end

    module MediaCategory
      AMPLIFY_VIDEO = 'AMPLIFY_VIDEO'
      TWEET_GIF     = 'TWEET_GIF'
      TWEET_IMAGE   = 'TWEET_IMAGE'
      TWEET_VIDEO   = 'TWEET_VIDEO'
    end

    module MediaType
      GIF   = 'GIF'
      IMAGE = 'IMAGE'
      VIDEO = 'VIDEO'
    end

    module Granularity
      HOUR  = 'HOUR'
      DAY   = 'DAY'
      TOTAL = 'TOTAL'
    end

    module AgeBucket
      AGE_13_TO_24 = 'AGE_13_TO_24'
      AGE_13_TO_34 = 'AGE_13_TO_34'
      AGE_13_TO_49 = 'AGE_13_TO_49'
      AGE_13_TO_54 = 'AGE_13_TO_54'
      AGE_OVER_13  = 'AGE_OVER_13'
      AGE_18_TO_34 = 'AGE_18_TO_34'
      AGE_18_TO_49 = 'AGE_18_TO_49'
      AGE_18_TO_54 = 'AGE_18_TO_54'
      AGE_OVER_18  = 'AGE_OVER_18'
      AGE_21_TO_34 = 'AGE_21_TO_34'
      AGE_21_TO_49 = 'AGE_21_TO_49'
      AGE_21_TO_54 = 'AGE_21_TO_54'
      AGE_OVER_21  = 'AGE_OVER_21'
      AGE_25_TO_49 = 'AGE_25_TO_49'
      AGE_25_TO_54 = 'AGE_25_TO_54'
      AGE_OVER_25  = 'AGE_OVER_25'
      AGE_35_TO_49 = 'AGE_35_TO_49'
      AGE_35_TO_54 = 'AGE_35_TO_54'
      AGE_OVER_35  = 'AGE_OVER_35'
      AGE_OVER_50  = 'AGE_OVER_50'
    end

    module Events
      MUSIC_AND_ENTERTAINMENT = 'MUSIC_AND_ENTERTAINMENT'
      SPORTS                  = 'SPORTS'
      HOLIDAY                 = 'HOLIDAY'
      CONFERENCE              = 'CONFERENCE'
      OTHER                   = 'OTHER'
    end

    module Sentiment
      ALL = 'ALL'
      POSITIVE_ONLY = 'POSITIVE_ONLY'
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

    module PermissionLevel
      READ_ONLY = 'READ_ONLY'
      READ_WRITE = 'READ_WRITE'
    end

    module TrackingPartner
      DOUBLE_CLICK = 'DOUBLE_CLICK'
    end

    module ConversationType
      EVENT = 'EVENT'
      HANDLE = 'HANDLE'
      HASHTAG = 'HASHTAG'
    end

    module LookalikeExpansion
      DEFINED = 'DEFINED'
      EXPANDED = 'EXPANDED'
    end

    module TweetType
      DRAFT = 'DRAFT'
      PUBLISHED = 'PUBLISHED'
      SCHEDULED = 'SCHEDULED'
    end

    module TimelineType
      ALL = 'ALL'
      NULLCAST = 'NULLCAST'
      ORGANIC = 'ORGANIC'
    end
  end
end
