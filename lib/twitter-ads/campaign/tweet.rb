# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Tweet

    # cannot instaniate Tweet, only including class methods for stats
    extend TwitterAds::Analytics::ClassMethods

    RESOURCE_CREATE = "/#{TwitterAds::API_VERSION}/" \
                      'accounts/%{account_id}/tweet' # @api private

    class << self

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
