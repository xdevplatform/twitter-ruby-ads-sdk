# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Tweet

    # cannot instaniate Tweet, only including class methods for stats
    extend TwitterAds::Analytics::ClassMethods

    RESOURCE_COLLECTION = '/0/accounts/%{account_id}/tweet/preview' # @api private
    RESOURCE_STATS      = '/0/stats/accounts/%{account_id}/organic_tweets' # @api private
    RESOURCE            = '/0/accounts/%{account_id}/tweet/preview/%{id}' # @api private

    class << self

      # Returns an HTML preview of a tweet, either new or existing
      #
      # @example
      #   Tweet.preview(account, status: 'potatoes can be deadly...')
      #   Tweet.preview(account, id: 634798319504617472)
      #
      # @param client [Client] The Client object instance.
      # @param account [Account] The Account object instance.
      # @param opts [Hash] A hash of options.
      #
      # @option opts [Integer] :id The ID of an existing Tweet you want to preview.
      # @option opts [String] :status The text of your status update, up to 140 characters.
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

        # url encodes statuss message if present
        opts[:status] = URI.escape(opts[:status]) if opts.key?(:status)

        # handles array to string conversion for media IDs
        if opts.key?(:media_ids) && opts[:media_ids].respond_to?(:join)
          opts[:media_ids] = opts[:media_ids].join(',')
        end

        response = TwitterAds::Request.new(account.client, :get, resource, params: opts).perform
        response.body[:data]
      end

    end

  end
end
