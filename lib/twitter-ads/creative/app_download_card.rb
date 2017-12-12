# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class AppDownloadCard

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

      property :app_country_code
      property :app_cta
      property :custom_icon_media_id
      property :custom_app_description
      property :iphone_app_id
      property :iphone_deep_link
      property :ipad_app_id
      property :ipad_deep_link
      property :googleplay_app_id
      property :googleplay_deep_link
      property :name

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                            'accounts/%{account_id}/cards/app_download'.freeze # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" +
                 'accounts/%{account_id}/cards/app_download/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
