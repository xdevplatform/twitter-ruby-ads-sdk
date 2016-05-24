# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class ImageAppDownloadCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :preview_url, read_only: true
      property :deleted, type: :bool, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true

      property :name
      property :app_country_code
      property :iphone_app_id
      property :iphone_deep_link
      property :ipad_app_id
      property :ipad_deep_link
      property :googleplay_app_id
      property :googleplay_deep_link
      property :app_cta
      property :wide_app_image_media_id

      RESOURCE_COLLECTION =
        '/1/accounts/%{account_id}/cards/image_app_download'.freeze # @api private
      RESOURCE = '/1/accounts/%{account_id}/cards/image_app_download/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
