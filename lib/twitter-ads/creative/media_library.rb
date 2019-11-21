# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class MediaLibrary

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      # read-only
      property :aspect_ratio, read_only: true
      property :created_at, type: :bool, read_only: true
      property :deleted, type: :bool, read_only: true
      property :duration, read_only: true
      property :media_status, read_only: true
      property :media_type, read_only: true
      property :media_url, read_only: true
      property :tweeted, type: :bool, read_only: true
      property :updated_at, type: :time, read_only: true
      property :poster_media_url, read_only: true

      # writable
      property :media_key
      property :description
      property :file_name
      property :name
      property :poster_media_key
      property :title

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                            'accounts/%{account_id}/media_library' # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" \
                 'accounts/%{account_id}/media_library/%{id}' # @api private

      def reload(account, opts = {})
        if @media_key
          resource = self.class::RESOURCE % { account_id: account.id, id: media_key }
          response = Request.new(account.client, :get, resource, params: opts).perform
          response.body[:data]
        end
      end

      def add
        params = to_params
        resource = self.class::RESOURCE_COLLECTION % { account_id: account.id }
        response = Request.new(account.client, :post, resource, params: params).perform
        from_response(response.body[:data])
      end

      def update
        params = to_params
        resource = self.class::RESOURCE % { account_id: account.id, id: media_key }
        response = Request.new(account.client, :put, resource, params: params).perform
        from_response(response.body[:data])
      end

      def delete!
        resource = RESOURCE % { account_id: account.id, id: media_key }
        response = Request.new(account.client, :delete, resource).perform
        from_response(response.body[:data])
      end

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
