# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class WebsiteCard

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
      property :website_title
      property :website_url
      property :website_cta
      property :image_media_id

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/cards/website' # @api private
      RESOURCE            = '/0/accounts/%{account_id}/cards/website/%{id}' # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
