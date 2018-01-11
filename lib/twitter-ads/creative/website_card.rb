# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class WebsiteCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :card_type, read_only: true
      property :card_uri, read_only: true
      property :created_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true
      property :id, read_only: true
      property :image, read_only: true
      property :image_display_height, read_only: true
      property :image_display_width, read_only: true
      property :preview_url, read_only: true
      property :updated_at, type: :time, read_only: true
      property :website_dest_url, read_only: true
      property :website_display_url, read_only: true

      property :image_media_id
      property :name
      property :website_title
      property :website_url

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/accounts/%{account_id}/cards/website"
                            .freeze # @api private
      RESOURCE            = "/#{TwitterAds::API_VERSION}/accounts/%{account_id}/cards/website/%{id}"
                            .freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
