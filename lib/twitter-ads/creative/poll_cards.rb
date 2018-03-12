# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class PollCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :card_type, read_only: true
      property :card_uri, read_only: true
      property :content_duration_seconds, read_only: true
      property :created_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true
      property :end_time, type: :time, read_only: true
      property :id, read_only: true
      property :image, read_only: true
      property :image_display_height, read_only: true
      property :image_display_width, read_only: true
      property :preview_url, read_only: true
      property :start_time, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :video_height, read_only: true
      property :video_hls_url, read_only: true
      property :video_poster_height, read_only: true
      property :video_poster_url, read_only: true
      property :video_poster_width, read_only: true
      property :video_url, read_only: true
      property :video_width, read_only: true

      property :duration_in_minutes
      property :name
      property :media_key
      property :first_choice
      property :second_choice
      property :third_choice
      property :fourth_choice

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                            'accounts/%{account_id}/cards/poll'.freeze # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" +
                 'accounts/%{account_id}/cards/poll/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
