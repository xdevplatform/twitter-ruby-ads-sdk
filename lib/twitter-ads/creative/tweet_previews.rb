# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class TweetPreview

      include TwitterAds::DSL
      include TwitterAds::Resource

      attr_reader :account

      property :preview, read_only: true
      property :tweet_id, read_only: true

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                            'accounts/%{account_id}/tweet_previews' # @api private

      def load(account, tweet_ids:, tweet_type:)
        params = { tweet_ids: Array(tweet_ids).join(',') }
        params[:tweet_type] = tweet_type
        resource = RESOURCE_COLLECTION % { account_id: account.id }
        request = Request.new(account.client, :get, resource, params: params)
        Cursor.new(self.class, request, init_with: [account])
      end

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
