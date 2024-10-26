# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class ImageConversationCard

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
      property :updated_at, type: :time, read_only: true
      property :media_url, read_only: true

      property :unlocked_image_media_key
      property :first_cta
      property :first_cta_tweet
      property :fourth_cta
      property :fourth_cta_tweet
      property :media_key
      property :name
      property :second_cta
      property :second_cta_tweet
      property :thank_you_text
      property :thank_you_url
      property :third_cta
      property :third_cta_tweet
      property :title
      property :image_display_height
      property :image_display_width

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                            'accounts/%{account_id}/cards/image_conversation' # @api private
      RESOURCE = "/#{TwitterAds::API_VERSION}/" \
                 'accounts/%{account_id}/cards/image_conversation/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
