# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'zlib'
require 'open-uri'

module TwitterAds
  module Analytics

    include TwitterAds::Enum

    ANALYTICS_MAP = {
      'TwitterAds::Campaign' => Entity::CAMPAIGN,
      'TwitterAds::LineItem' => Entity::LINE_ITEM,
      'TwitterAds::OrganicTweet' => Entity::ORGANIC_TWEET,
      'TwitterAds::Creative::PromotedAccount' => Entity::ACCOUNT,
      'TwitterAds::Creative::PromotedTweet' => Entity::PROMOTED_TWEET,
      'TwitterAds::Creative::MediaCreative' => Entity::MEDIA_CREATIVE
    }.freeze

    RESOURCE_STATS            = "/#{TwitterAds::API_VERSION}/" +
                                'stats/accounts/%{account_id}' # @api private
    RESOURCE_ASYNC_STATS      = "/#{TwitterAds::API_VERSION}/" +
                                'stats/jobs/accounts/%{account_id}' # @api private
    RESOURCE_ACTIVE_ENTITIES  = "/#{TwitterAds::API_VERSION}/" +
                                'stats/accounts/%{account_id}/active_entities' # @api private

    def self.included(klass)
      klass.send :include, InstanceMethods
      klass.extend ClassMethods
    end

    module InstanceMethods

      # Pulls a list of metrics for the current object instance.
      #
      # @example
      #   metric_groups = [:promoted_tweet_timeline_clicks, :promoted_tweet_search_clicks]
      #   object.stats(metrics)
      #
      # @param metric_groups [Array] A collection of metric groups to fetch.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Time] :start_time The starting time to use (default: 7 days ago).
      # @option opts [Time] :end_time The end time to use (default: now).
      # @option opts [Symbol] :granularity The granularity to use (default: :hour).
      #
      # @return [Array] The collection of stats requested.
      #
      # @see https://dev.twitter.com/ads/analytics/metrics-and-segmentation
      # @since 1.0.0
      def stats(metric_groups, opts = {})
        self.class.stats(account, [id], metric_groups, opts)
      end

    end

    module ClassMethods

      # Pulls a list of metrics for a specified set of object IDs.
      #
      # @example
      #   ids = ['7o4em', 'oc9ce', '1c5lji']
      #   metric_groups = [MetricGroups.MOBILE_CONVERSION, MetricGroups.ENGAGEMENT]
      #   object.stats(account, ids, metric_groups)
      #
      # @param account [Account] The Account object instance.
      # @param ids [Array] A collection of object IDs being targeted.
      # @param metric_groups [Array] A collection of metric_groups to be fetched.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Time] :start_time The starting time to use (default: 7 days ago).
      # @option opts [Time] :end_time The end time to use (default: now).
      # @option opts [Symbol] :granularity The granularity to use (default: :hour).
      # @option opts [Symbol] :placement The placement of entity (default: ALL_ON_TWITTER).
      #
      # @return [Array] The collection of stats requested.
      #
      # @see https://dev.twitter.com/ads/analytics/metrics-and-segmentation
      # @since 1.0.0

      def stats(account, ids, metric_groups, opts = {})
        # set default metric values
        end_time          = opts.fetch(:end_time, (Time.now - Time.now.sec - (60 * Time.now.min)))
        start_time        = opts.fetch(:start_time, end_time - (60 * 60 * 24 * 7)) # 7 days ago
        granularity       = opts.fetch(:granularity, :hour)
        start_utc_offset  = opts[:start_utc_offset] || opts[:utc_offset]
        end_utc_offset    = opts[:end_utc_offset] || opts[:utc_offset]
        placement         = opts.fetch(:placement, Placement::ALL_ON_TWITTER)

        params = {
          metric_groups: metric_groups.join(','),
          start_time: TwitterAds::Utils.to_time(start_time, granularity, start_utc_offset),
          end_time: TwitterAds::Utils.to_time(end_time, granularity, end_utc_offset),
          granularity: granularity.to_s.upcase,
          entity: ANALYTICS_MAP[name],
          placement: placement
        }

        params['entity_ids'] = ids.join(',')

        resource = self::RESOURCE_STATS % { account_id: account.id }
        response = Request.new(account.client, :get, resource, params: params).perform
        response.body[:data]
      end

      # Create an asynchronous analytics job for a given ads account.
      # A job_id is returned, which you can use to poll the
      # GET stats/jobs/accounts/:account_id endpoint, checking until the job is successful.
      #
      # @example
      #   ids = ['7o4em', 'oc9ce', '1c5lji']
      #   metric_groups = [MetricGroups.MOBILE_CONVERSION, MetricGroups.ENGAGEMENT]
      #   object.create_async_job(account, ids, metric_groups)
      #
      # @param account [Account] The Account object instance.
      # @param ids [Array] A collection of object IDs being targeted.
      # @param metric_groups [Array] A collection of metric_groups to be fetched.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Time] :start_time The starting time to use (default: 7 days ago).
      # @option opts [Time] :end_time The end time to use (default: now).
      # @option opts [Symbol] :granularity The granularity to use (default: :hour).
      # @option opts [Symbol] :placement The placement of entity (default: ALL_ON_TWITTER).
      # @option opts [Symbol] :segmentation_type The segmentation type to use (default: none).
      #
      # @return The response of creating job
      #
      # @see https://dev.twitter.com/ads/analytics/metrics-and-segmentation
      # @sync 1.0.0

      def create_async_job(account, ids, metric_groups, opts = {})
        # set default metric values
        end_time          = opts.fetch(:end_time, (Time.now - Time.now.sec - (60 * Time.now.min)))
        start_time        = opts.fetch(:start_time, end_time - 604_800) # 7 days ago
        granularity       = opts.fetch(:granularity, :hour)
        start_utc_offset  = opts[:start_utc_offset] || opts[:utc_offset]
        end_utc_offset    = opts[:end_utc_offset] || opts[:utc_offset]
        placement         = opts.fetch(:placement, Placement::ALL_ON_TWITTER)
        segmentation_type = opts.fetch(:segmentation_type, nil)
        country = opts.fetch(:country, nil)
        platform = opts.fetch(:platform, nil)

        params = {
          metric_groups: metric_groups.join(','),
          start_time: TwitterAds::Utils.to_time(start_time, granularity, start_utc_offset),
          end_time: TwitterAds::Utils.to_time(end_time, granularity, end_utc_offset),
          granularity: granularity.to_s.upcase,
          entity: ANALYTICS_MAP[name],
          placement: placement,
          country: country,
          platform: platform
        }.compact

        params[:segmentation_type] = segmentation_type.to_s.upcase if segmentation_type
        params['entity_ids'] = ids.join(',')

        resource = self::RESOURCE_ASYNC_STATS % { account_id: account.id }
        puts 'my resource is ' + resource
        response = Request.new(account.client, :post, resource, params: params).perform
        response.body[:data]
      end

      # Check async job status.
      # GET /#{TwitterAds::API_VERSION}/stats/jobs/accounts/:account_id
      #
      # @example
      #   TwitterAds::LineItem.check_async_job_status(account, job_id: '1357343438724431305')
      #
      # @param account [Account] The Account object instance.
      # @option opts [String] :job_id The starting time to use (default: 7 days ago).
      #
      # @return A cursor of job statuses

      def check_async_job_status(account, opts = {})
        # set default values
        job_ids = opts.fetch(:job_ids, nil)
        params = {}
        params[:job_ids] = Array.wrap(job_ids).join(',') if job_ids

        resource = self::RESOURCE_ASYNC_STATS % { account_id: account.id }
        request = Request.new(account.client, :get, resource, params: params)
        Cursor.new(nil, request, init_with: [account])
      end

      # Fetch async job data for a completed job.
      # Raises HTTP 404 exception, otherwise retries up to 5 times with exponential backoff.
      #
      # @example
      #   response_data = TwitterAds::LineItem.fetch_async_job_data(account, file_url)
      #
      # @param data_url [String] The URL from the successful completion of an async job.
      #
      # @return A cursor of job statuses

      def fetch_async_job_data(data_url)
        tries = 0
        begin
          tries += 1
          raw_file = open(data_url)
          unzipped_file = Zlib::GzipReader.new(raw_file)
          response_data = unzipped_file.read
          response = JSON.parse(response_data)
          response['data']
        rescue OpenURI::HTTPError => e
          unless e.io.status[0] == '404'
            if tries < 5
              sleep(2**tries)
              retry
            end
          end
        end
      end

      def active_entities(account, start_time:, end_time:, **opts)
        entity_type = name
        granularity       = opts.fetch(:granularity, nil)
        start_utc_offset  = opts[:start_utc_offset] || opts[:utc_offset]
        end_utc_offset    = opts[:end_utc_offset] || opts[:utc_offset]

        if entity_type == 'OrganicTweet'
          raise "'OrganicTweet' not support with 'active_entities'"
        end

        params = {
          entity: ANALYTICS_MAP[entity_type],
          start_time: TwitterAds::Utils.to_time(start_time, granularity, start_utc_offset),
          end_time: TwitterAds::Utils.to_time(end_time, granularity, end_utc_offset)
        }

        opts.each { |k, v|
          params[k] = if v.instance_of?(Array)
                        v.join(',')
                      else
                        v
                      end
        }

        resource = self::RESOURCE_ACTIVE_ENTITIES % { account_id: account.id }
        response = Request.new(account.client, :get, resource, params: params).perform
        response.body[:data]
      end

    end
  end
end
