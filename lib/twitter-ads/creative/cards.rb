# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class Cards

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :card_type, read_only: true
      property :card_uri, read_only: true
      property :created_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true
      property :updated_at, type: :time, read_only: true
      # these are writable, but not in the sense that they can be set on an object and then saved
      property :name
      property :components

      RESOURCE = "/#{TwitterAds::API_VERSION}/" +
                 'accounts/%{account_id}/cards/%{id}' # @api private
      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                            'accounts/%{account_id}/cards' # @api private

      def save
        headers = { 'Content-Type' => 'application/json' }
        params = { 'name': name, 'components': components }
        if @id
          resource = RESOURCE % {
            account_id: account.id,
            id: id
          }
          request = Request.new(account.client,
                                :put,
                                resource,
                                headers: headers,
                                body: params.to_json)
        else
          resource = RESOURCE_COLLECTION % {
            account_id: account.id
          }
          request = Request.new(account.client,
                                :post,
                                resource,
                                headers: headers,
                                body: params.to_json)
        end

        response = request.perform
        from_response(response.body[:data])
      end

      def initialize(account)
        @account = account
        self
      end
    end

  end
end
