# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class VideoConversationCard

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
      property :media_url, read_only: true
      property :poster_media_url, read_only: true

      property :unlocked_image_media_key
      property :unlocked_video_media_key
      property :fourth_cta
      property :fourth_cta_tweet
      property :poster_media_key
      property :first_cta
      property :first_cta_tweet
      property :name
      property :second_cta
      property :second_cta_tweet
      property :thank_you_text
      property :thank_you_url
      property :third_cta
      property :third_cta_tweet
      property :title
      property :media_key

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                            'accounts/%{account_id}/cards/video_conversation' # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" \
                 'accounts/%{account_id}/cards/video_conversation/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
