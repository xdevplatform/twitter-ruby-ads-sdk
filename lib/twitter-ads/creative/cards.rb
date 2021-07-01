# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class Cards

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :card_uri, read_only: true
      property :created_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true
      property :updated_at, type: :time, read_only: true
      # these are writable, but not in the sense that they can be set on an object and then saved
      property :name, read_only: true
      property :components, read_only: true

      RESOURCE = "/#{TwitterAds::API_VERSION}/" +
                 'accounts/%{account_id}/cards' # @api private

      def load(*)
        raise ArgumentError.new(
          "'Cards' object has no attribute 'load'")
      end

      def reload(*)
        raise ArgumentError.new(
          "'Cards' object has no attribute 'reload'")
      end

      def create(account, name, components)
        resource = RESOURCE % { account_id: account.id }
        params = { 'name': name, 'components': components }
        headers = { 'Content-Type' => 'application/json' }
        response = Request.new(account.client,
                               :post,
                               resource,
                               headers: headers,
                               body: params.to_json).perform
        from_response(response.body[:data])
      end

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
