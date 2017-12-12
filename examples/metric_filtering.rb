# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'twitter-ads'
require 'yaml'

module TwitterAds

  # Example of filtering metrics by line-item details.
  #
  # Usage Example:
  # http://showterm.io/f242a11450bcfc4740fdd
  #
  class Metrics

    METRIC_FAMILIES = {
      engagement: %w(
        billed_engagements
        billed_follows
        promoted_account_follows
        promoted_tweet_profile_card_engagements
        promoted_tweet_profile_clicks
        promoted_tweet_profile_engagements
        promoted_tweet_profile_favorites
        promoted_tweet_profile_follows
        promoted_tweet_profile_replies
        promoted_tweet_profile_retweets
        promoted_tweet_profile_url_clicks
        promoted_tweet_search_card_engagements
        promoted_tweet_search_clicks
        promoted_tweet_search_engagements
        promoted_tweet_search_favorites
        promoted_tweet_search_follows
        promoted_tweet_search_replies
        promoted_tweet_search_retweets
        promoted_tweet_search_url_clicks
        promoted_tweet_timeline_card_engagements
        promoted_tweet_timeline_clicks
        promoted_tweet_timeline_engagements
        promoted_tweet_timeline_favorites
        promoted_tweet_timeline_follows
        promoted_tweet_timeline_replies
        promoted_tweet_timeline_retweets
        promoted_tweet_timeline_url_clicks
      ),
      conversion: %w(
        conversion_custom
        conversion_downloads
        conversion_order_quantity
        conversion_purchases
        conversion_sale_amount
        conversion_sign_ups
        conversion_site_visits
      ),
      media: %w(
        promoted_tweet_profile_media_views
        promoted_tweet_search_media_views
        promoted_tweet_timeline_media_views
        promoted_tweet_tpn_media_views
      ),
      mobile_lifetime_value: %w(
        mobile_lifetime_value_conversion_breakdown
        mobile_lifetime_value_conversion_sale_amount_local_micro_breakdown
        mobile_lifetime_value_conversion_order_quantity_breakdown
      ),
      mobile_app_promotion: %w(
        mobile_conversion_achievement_unlocked
        mobile_conversion_achievement_unlocked_breakdown
        mobile_conversion_add_to_cart
        mobile_conversion_add_to_cart_breakdown
        mobile_conversion_add_to_wishlist
        mobile_conversion_add_to_wishlist_breakdown
        mobile_conversion_added_payment_infos
        mobile_conversion_added_payment_infos_breakdown
        mobile_conversion_checkout_initiated
        mobile_conversion_checkout_initiated_breakdown
        mobile_conversion_content_views
        mobile_conversion_content_views_breakdown
        mobile_conversion_installs
        mobile_conversion_installs_breakdown
        mobile_conversion_invites
        mobile_conversion_invites_breakdown
        mobile_conversion_level_achieved
        mobile_conversion_level_achieved_breakdown
        mobile_conversion_logins
        mobile_conversion_logins_breakdown
        mobile_conversion_order_quantity
        mobile_conversion_purchases
        mobile_conversion_purchases_breakdown
        mobile_conversion_rated
        mobile_conversion_rated_breakdown
        mobile_conversion_re_engages
        mobile_conversion_re_engages_breakdown
        mobile_conversion_reservations
        mobile_conversion_reservations_breakdown
        mobile_conversion_sale_amount_local_micro
        mobile_conversion_searches
        mobile_conversion_searches_breakdown
        mobile_conversion_shares
        mobile_conversion_shares_breakdown
        mobile_conversion_sign_ups
        mobile_conversion_sign_ups_breakdown
        mobile_conversion_spent_credits
        mobile_conversion_spent_credits_breakdown
        mobile_conversion_tutorial_completes
        mobile_conversion_tutorial_completes_breakdown
        mobile_conversion_updates
        mobile_conversion_updates_breakdown
        promoted_tweet_app_install_attempts
        promoted_tweet_app_open_attempts
      ),
      spend: %w(
        billed_charge_local_micro
      ),
      twitter_audience_platform: %w(
        promoted_tweet_tpn_card_engagements
        promoted_tweet_tpn_engagement_rate
        promoted_tweet_tpn_engagements
        promoted_tweet_tpn_clicks
        promoted_tweet_tpn_favorites
        promoted_tweet_tpn_follows
        promoted_tweet_tpn_impressions
        promoted_tweet_tpn_replies
        promoted_tweet_tpn_retweets
        promoted_tweet_tpn_url_clicks
      ),
      video: %w(
        promoted_video_cta_clicks
        promoted_video_replays
        promoted_video_total_views
        promoted_video_views_100
        promoted_video_views_25
        promoted_video_views_50
        promoted_video_views_75
      ),
      other: %w(
        promoted_account_follow_rate
        promoted_account_impressions
        promoted_account_profile_visits
        promoted_tweet_profile_impressions
        promoted_tweet_search_engagement_rate
        promoted_tweet_search_impressions
        promoted_tweet_timeline_engagement_rate
        promoted_tweet_timeline_impressions
      )
    }.freeze

    OBJECTIVES = {
      app_engagements: [
        :engagement,
        :mobile_app_promotion,
        :spend,
        :twitter_audience_platform,
        :video,
        :other
      ],
      app_installs: [
        :engagement,
        :mobile_app_promotion,
        :mobile_lifetime_value,
        :other,
        :spend,
        :twitter_audience_platform,
        :video
      ],
      brand_engagements: [
        :conversion,
        :engagement,
        :media,
        :spend,
        :twitter_audience_platform,
        :video,
        :other
      ],
      custom: [
        :conversion,
        :engagement,
        :media,
        :mobile_app_promotion,
        :mobile_lifetime_value,
        :spend,
        :twitter_audience_platform,
        :video,
        :other
      ],
      followers: [
        :conversion,
        :engagement,
        :media,
        :mobile_app_promotion,
        :spend,
        :twitter_audience_platform,
        :video,
        :other
      ],
      preroll_views: [
        :engagement,
        :media,
        :mobile_app_promotion,
        :spend,
        :twitter_audience_platform,
        :video,
        :other
      ],
      tweet_engagements: [
        :conversion,
        :engagement,
        :media,
        :spend,
        :video,
        :other
      ],
      qualified_views: [
        :engagement,
        :media,
        :spend,
        :video,
        :other
      ],
      video_views: [
        :engagement,
        :spend,
        :twitter_audience_platform,
        :video,
        :other
      ],
      website_clicks: [
        :conversion,
        :engagement,
        :media,
        :spend,
        :twitter_audience_platform,
        :other
      ],
      website_conversions: [
        :conversion,
        :engagement,
        :media,
        :spend,
        :twitter_audience_platform,
        :other
      ]
    }.freeze

    # Sets up the object with the correct account and client information.
    #
    # @example
    #   metric_filter = TwitterAds::Metric.new('xyz1')
    #
    # @param account_id [String] The ID for the account to be used.
    # @param client [Client] Optional client instance to be used. Will default to ~/.twurlrc info.
    # @param mact_enabled [Boolean] Indicates the account has a MACT partner setup (default: false).
    #
    # @return [self] The configured object instance.
    def initialize(account_id, client = nil, mact_enabled = false)
      @client = client || create_client
      @account = @client.accounts(account_id)
      @mact_enabled = !!mact_enabled
      raise ArgumentError.new("Error! Account (#{account_id}) not found.") unless @account
      self
    end

    # Determines relevant metrics from a list of line item IDs.
    #
    # @example
    #   metric_filter.filter(line_item_ids)
    #
    # @param line_items [String/Array] A list of one or more line item IDs.
    #
    # @return [Hash] A hash with relevant metrics for each line item.
    def filter(*line_items)
      result = {}
      params = { line_item_ids: line_items.join(','), with_deleted: true }
      @account.line_items(nil, params).each do |line_item|
        # filter by objective
        objective = line_item.objective.downcase.to_sym
        metrics   = OBJECTIVES[objective].map { |family| METRIC_FAMILIES[family] }.flatten

        # filter by placements
        placements = line_item.placements.map { |p| p.downcase.to_sym }
        filter_placements(metrics, placements)

        # filter by product
        product = line_item.product_type.downcase.to_sym
        filter_product(metrics, product)

        # filter LTV metrics unless account has a MACT partner setup
        metrics.reject! { |m| m.include?('mobile_lifetime_value_') } unless @mact_enabled

        result[line_item.id] = metrics
      end
      result
    end

    private

    def filter_placements(metrics, placements)
      # return, nothing to exclude
      return if placements.include?(:all_on_twitter) && placements.include?(:publisher_network)

      # remove all TAP-related metrics unless publisher_network
      metrics.reject! { |m| m.include?('_tpn_') } unless placements.include?(:publisher_network)

      # remove all timeline-related metrics unless twitter_timeline
      metrics.reject! { |m| m.include?('_timeline_') } unless placements.include?(:twitter_timeline)

      # remove all search-related metrics unless twitter_search
      metrics.reject! { |m| m.include?('_search_') } unless placements.include?(:twitter_search)

      # remove all profile-related metrics unless twitter_profile
      metrics.reject! { |m| m.include?('_profile_') } unless placements.include?(:twitter_profile)
    end

    def filter_product(metrics, product)
      metrics.reject! { |m| m.include?('promoted_tweet_') } unless product == :promoted_tweets
      unless product == :promoted_account
        metrics.reject! { |m| m.include?('promoted_account_') || m == 'billed_follows' }
      end
    end

    def create_client
      if File.exist?(File.expand_path('~/.twurlrc'))
        twurl_config    = YAML.safe_load(File.read(File.expand_path('~/.twurlrc')))
        profile_name    = twurl_config['configuration']['default_profile'][0]
        profile_key     = twurl_config['configuration']['default_profile'][1]
        default_profile = twurl_config['profiles'][profile_name][profile_key]
        TwitterAds::Client.new(
          default_profile['consumer_key'],
          default_profile['consumer_secret'],
          default_profile['token'],
          default_profile['secret']
        )
      else
        raise ArgumentError.new('Error! No client specified and no ~/.twurlrc found.')
      end
    end

  end
end
