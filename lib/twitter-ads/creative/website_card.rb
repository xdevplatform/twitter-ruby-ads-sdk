# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class WebsiteCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      # @return [String] The base-36 string identifer for this card.
      property :id, read_only: true
      # @return [String] The card preview url.
      property :preview_url, read_only: true
      # @return [Boolean] A boolean value indicating if the object has been soft-deleted.
      property :deleted, type: :bool, read_only: true
      # @return [Time] A timestamp of when the object was first created.
      property :created_at, type: :time, read_only: true
      # @return [Time] A timestamp of when the object was last updated.
      property :updated_at, type: :time, read_only: true
      # @return [String] A non-user facing name for this object.
      property :name
      # @return [String] The title of the website card. (Max: 70 characters)
      property :website_title
      # @return [String] The URL of the website to redirect a user to. (Max: 200 characters)
      property :website_url
      # @return [String] An enum value for the call-to-action prompt.
      # @deprecated Please see https://t.co/deprecated-website-card-cta for more info.
      property :website_cta
      # @return [Integer] The Media ID for an uploaded image to include in the website card.
      property :image_media_id

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/cards/website'.freeze # @api private
      RESOURCE            = '/0/accounts/%{account_id}/cards/website/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

      # Overload for CTA deprecation warning.
      # @private
      def website_cta=(value)
        warn "[DEPRECATED] The 'website_cta' property has been deprecated from #{self.class}. " \
             'Please see https://t.co/deprecated-website-card-cta for more info.'
        @website_cta = value
      end

    end

  end
end
