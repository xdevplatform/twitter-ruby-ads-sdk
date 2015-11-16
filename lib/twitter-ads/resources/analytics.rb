# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Analytics

    CLASS_ID_MAP = {
      'TwitterAds::LineItem'                => :line_item_ids,
      'TwitterAds::OrganicTweet'            => :tweet_ids,
      'TwitterAds::Tweet'                   => :tweet_ids,
      'TwitterAds::Creative::PromotedTweet' => :promoted_tweet_ids
    } # @api private

    def self.included(klass)
      klass.send :include, InstanceMethods
      klass.extend ClassMethods
    end

    module InstanceMethods

      # Pulls a list of metrics for the current object instance.
      #
      # @example
      #   metrics = [:promoted_tweet_timeline_clicks, :promoted_tweet_search_clicks]
      #   object.stats(metrics)
      #
      # @param metrics [Array] A collection of valid metrics to be fetched.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Time] :start_time The starting time to use (default: 7 days ago).
      # @option opts [Time] :end_time The end time to use (default: now).
      # @option opts [Symbol] :granularity The granularity to use (default: :hour).
      # @option opts [Symbol] :segmentation_type The segmentation type to use (default: none).
      #
      # @return [Array] The collection of stats requested.
      #
      # @see https://dev.twitter.com/ads/analytics/metrics-and-segmentation
      # @since 0.1.0
      def stats(metrics, opts = {})
        self.class.stats(account, [id], metrics, opts)
      end

    end

    module ClassMethods

      # Pulls a list of metrics for a specified set of object IDs.
      #
      # @example
      #   ids = ['7o4em', 'oc9ce', '1c5lji']
      #   metrics = [:promoted_tweet_timeline_clicks, :promoted_tweet_search_clicks]
      #   object.stats(account, ids, metrics)
      #
      # @param account [Account] The Account object instance.
      # @param ids [Array] A collection of object IDs being targeted.
      # @param metrics [Array] A collection of valid metrics to be fetched.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Time] :start_time The starting time to use (default: 7 days ago).
      # @option opts [Time] :end_time The end time to use (default: now).
      # @option opts [Symbol] :granularity The granularity to use (default: :hour).
      # @option opts [Symbol] :segmentation_type The segmentation type to use (default: none).
      #
      # @return [Array] The collection of stats requested.
      #
      # @see https://dev.twitter.com/ads/analytics/metrics-and-segmentation
      # @since 0.1.0
      def stats(account, ids, metrics, opts = {})
        # set default metric values
        end_time          = opts.fetch(:end_time, Time.now)
        start_time        = opts.fetch(:start_time, end_time - 604_800) # 7 days ago
        granularity       = opts.fetch(:granularity, :hour)
        segmentation_type = opts.fetch(:segmentation_type, nil)

        params = {
          metrics: metrics.join(','),
          start_time: TwitterAds::Utils.to_time(start_time, granularity),
          end_time: TwitterAds::Utils.to_time(end_time, granularity),
          granularity: granularity.to_s.upcase
        }
        params[:segmentation_type] = segmentation_type.to_s.upcase if segmentation_type
        params[TwitterAds::Analytics::CLASS_ID_MAP[name]] = ids.join(',')

        resource = self::RESOURCE_STATS % { account_id: account.id }
        response = Request.new(account.client, :get, resource, params: params).perform
        response.body[:data]
      end

    end

  end
end
