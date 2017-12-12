# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class VideoWebsiteCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :account_id, read_only: true
      property :card_type, read_only: true
      property :card_uri, read_only: true
      property :created_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true
      property :id, read_only: true
      property :preview_url, read_only: true
      property :updated_at, type: :time, read_only: true
      property :video_content_id, read_only: true
      property :video_height, read_only: true
      property :video_hls_url, read_only: true
      property :video_owner_id, read_only: true
      property :video_poster_height, read_only: true
      property :video_poster_url, read_only: true
      property :video_poster_width, read_only: true
      property :video_url, read_only: true
      property :video_width, read_only: true
      property :website_display_url, read_only: true
      property :website_dest_url, read_only: true

      property :name
      property :title
      property :video_id
      property :website_url

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/accounts/%{account_id}/cards/video_website"
                            .freeze # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" +
                 'accounts/%{account_id}/cards/video_website/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
