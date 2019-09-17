# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class Tweets

      include TwitterAds::DSL
      include TwitterAds::Resource

      attr_reader :account

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                            'accounts/%{account_id}/tweets' # @api private

      def self.all(account, opts = {})
        params = TwitterAds::Utils.flatten_params(opts)
        resource = self::RESOURCE_COLLECTION % { account_id: account.id }
        request = Request.new(account.client, :get, resource, params: params)
        Cursor.new(nil, request, init_with: [account])
      end

    end
  end
end
