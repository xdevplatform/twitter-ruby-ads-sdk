# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class VideoAppDownloadCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :card_type, read_only: true
      property :card_uri, read_only: true
      property :created_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true
      property :id, read_only: true
      property :updated_at, type: :time, read_only: true
      property :video_owner_id, read_only: true
      property :poster_media_url, read_only: true
      property :media_url, read_only: true

      property :country_code
      property :app_cta
      property :poster_media_key
      property :ios_app_store_identifier
      property :ios_deep_link
      property :googleplay_app_id
      property :googleplay_deep_link
      property :name
      property :media_key

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                            'accounts/%{account_id}/cards/video_app_download' # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" \
                 'accounts/%{account_id}/cards/video_app_download/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
