# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class ImageConversationCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :preview_url, read_only: true
      property :image, read_only: true
      property :deleted, type: :bool, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true

      property :name
      property :title
      property :first_cta
      property :first_cta_tweet
      property :second_cta
      property :second_cta_tweet
      property :thank_you_text
      property :thank_you_url
      property :image_media_id

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/cards/image_conversation' # @api private
      RESOURCE = '/0/accounts/%{account_id}/cards/image_conversation/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
