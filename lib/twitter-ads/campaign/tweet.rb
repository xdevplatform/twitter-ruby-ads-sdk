# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Tweet

    # cannot instaniate Tweet, only including class methods for stats
    extend TwitterAds::Analytics::ClassMethods

    RESOURCE_COLLECTION  = "/#{TwitterAds::API_VERSION}/" +
                           'accounts/%{account_id}/tweet/preview'.freeze # @api private
    RESOURCE_STATS       = "/#{TwitterAds::API_VERSION}/" +
                           'stats/accounts/%{account_id}'.freeze # @api private
    RESOURCE_ASYNC_STATS = "/#{TwitterAds::API_VERSION}/" +
                           'stats/jobs/accounts/%{account_id}'.freeze # @api private
    RESOURCE             = "/#{TwitterAds::API_VERSION}/" +
                           'accounts/%{account_id}/tweet/preview/%{id}'.freeze # @api private
    RESOURCE_CREATE      = "/#{TwitterAds::API_VERSION}/" +
                           'accounts/%{account_id}/tweet'.freeze # @api private

    class << self

      # Returns an HTML preview of a tweet, either new or existing
      #
      # @example
      #   Tweet.preview(account, text: 'potatoes can be deadly...')
      #   Tweet.preview(account, id: 634798319504617472)
      #
      # @param client [Client] The Client object instance.
      # @param account [Account] The Account object instance.
      # @param opts [Hash] A hash of options.
      #
      # @option opts [Integer] :id The ID of an existing Tweet you want to preview.
      # @option opts [String] :text The text of your status update.
      # @option opts [Array] :media_ids A list of up to four media IDs to associate with the Tweet.
      # @option opts [String] :card_id The base-36 ID of a revenue card to be embedded in the Tweet.
      # @option opts [String] :preview_target The target to render the Tweet preview
      #   for (eg. TWITTER_TIMELINES).
      #
      # @return [Array] An array containing platforms & their respective tweet previews
      #
      # @since 0.2.0
      # @see https://dev.twitter.com/ads/reference/get/accounts/%3Aaccount_id/tweet/preview
      def preview(account, opts = {})
        resource = opts.key?(:id) ? RESOURCE : RESOURCE_COLLECTION
        resource = resource % { account_id: account.id, id: opts.delete(:id) }

        # url encodes status message if present
        opts[:text] = URI.escape(opts[:text]) if opts.key?(:text)

        # handles array to string conversion for media IDs
        if opts.key?(:media_ids) && opts[:media_ids].respond_to?(:join)
          opts[:media_ids] = opts[:media_ids].join(',')
        end

        response = TwitterAds::Request.new(account.client, :get, resource, params: opts).perform
        response.body[:data]
      end

      # Creates a "Promoted-Only" Tweet using the specialized Ads API end point.
      #
      # @param opts [Hash] A hash of options.
      #
      # @option opts [String] :text The main Tweet body.
      # @option opts [Array] :media_ids A list of up to four media IDs to associate with the Tweet.
      # @option opts [Integer] :as_user_id The user ID whom you are posting the Tweet on behalf of.
      # @option opts [Boolean] :trim_user Excludes the user object from the hydrated Tweet response.
      # @option opts [String] :video_id The Video UUID to be associated with thie Tweet.
      # @option opts [String] :video_title An optional title to be included.
      # @option opts [String] :video_description An optional description to be included.
      # @option opts [String] :video_cta An optional CTA value for the associated video.
      # @option opts [String] :video_cta_value The value for the corresponding CTA.
      #
      # @since 0.3.0
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/tweet
      #
      # @return [Hash] A hash containing the newly created Tweet object.
      def create(account, opts = {})
        resource = RESOURCE_CREATE % { account_id: account.id }
        response = TwitterAds::Request.new(account.client, :post, resource, params: opts).perform
        response.body[:data]
      end

    end

  end
end
