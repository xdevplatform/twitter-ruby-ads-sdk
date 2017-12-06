# frozen_string_literal: true
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
      # @return [String] An enum value for the call-to-action prompt.
      # @deprecated Please see https://t.co/deprecated-website-card-cta for more info.
      property :website_cta
      property :image_media_id

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/accounts/%{account_id}/cards/website"
                            .freeze # @api private
      RESOURCE            = "/#{TwitterAds::API_VERSION}/accounts/%{account_id}/cards/website/%{id}"
                            .freeze # @api private

      def initialize(account)
        @account = account
        self
      end

      # Overload for CTA deprecation warning.
      # @private
      def website_cta=(value)
        TwitterAds::Utils.deprecated(
          "#{self.class}#website_cta", refer: 'https://t.co/deprecated-website-card-cta')
        @website_cta = value
      end

    end

  end
end
