# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Tweet

    RESOURCE_COLLECTION = '/0/accounts/%{account_id}/tweet/preview'
    RESOURCE = '/0/accounts/%{account_id}/tweet/preview/%{id}'

    class << self

      # Method to return preview of a tweet, either new or existing
      #
      # @client [Client] The Client object instance.
      # @param account [Account] The Account object instance.
      # @param opts = {} [Hash] A hash of options. :id indicates ID of existing tweet to preview
      #
      # @return [Array] An array containing platforms & their respective tweet previews
      def preview(account, opts = {})
        resource = nil
        if opts.key?(:id)
          resource = RESOURCE % { account_id: account.id, id: opts.delete(:id) }
        else
          resource = RESOURCE_COLLECTION % { account_id: account.id }
        end
        response = TwitterAds::Request.new(account.client, :get, resource, params: opts).perform
        response.body[:data]
      end

    end

  end
end
