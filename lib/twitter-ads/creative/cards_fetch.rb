# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Creative

    class CardsFetch

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :country_code, read_only: true
      property :app_cta, read_only: true
      property :card_type, read_only: true
      property :card_uri, read_only: true
      property :content_duration_seconds, read_only: true
      property :created_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true
      property :duration_in_minutes, read_only: true
      property :end_time, type: :time, read_only: true
      property :first_choice, read_only: true
      property :first_cta, read_only: true
      property :first_cta_tweet, read_only: true
      property :first_cta_welcome_message_id, read_only: true
      property :fouth_choice, read_only: true
      property :fouth_cta, read_only: true
      property :fouth_cta_tweet, read_only: true
      property :fourth_cta_welcome_message_id, read_only: true
      property :googleplay_app_id, read_only: true
      property :googleplay_deep_link, read_only: true
      property :id, read_only: true
      property :image, read_only: true
      property :image_display_height, read_only: true
      property :image_display_width, read_only: true
      property :ios_app_store_identifier, read_only: true
      property :ios_deep_link, read_only: true
      property :name, read_only: true
      property :recipient_user_id, read_only: true
      property :second_choice, read_only: true
      property :second_cta, read_only: true
      property :second_cta_tweet, read_only: true
      property :second_cta_welcome_message_id, read_only: true
      property :start_time, type: :time, read_only: true
      property :thank_you_text, read_only: true
      property :thank_you_url, read_only: true
      property :third_choice, read_only: true
      property :third_cta, read_only: true
      property :third_cta_tweet, read_only: true
      property :third_cta_welcome_message_id, read_only: true
      property :title, read_only: true
      property :updated_at, type: :time, read_only: true
      property :video_content_id, read_only: true
      property :video_height, read_only: true
      property :video_hls_url, read_only: true
      property :video_owner_id, read_only: true
      property :video_poster_height, read_only: true
      property :video_poster_url, read_only: true
      property :video_poster_width, read_only: true
      property :video_width, read_only: true
      property :video_url, read_only: true
      property :website_dest_url, read_only: true
      property :website_display_url, read_only: true
      property :website_shortened_url, read_only: true
      property :website_title, read_only: true
      property :website_url, read_only: true
      property :wide_app_image, read_only: true
      property :id, read_only: true

      FETCH_URI = "/#{TwitterAds::API_VERSION}/" +
                  'accounts/%{account_id}/cards/all' # @api private
      FETCH_ID  = "/#{TwitterAds::API_VERSION}/" +
                  'accounts/%{account_id}/cards/all/%{id}' # @api private

      def all(*)
        raise ArgumentError.new(
          "'CardsFetch' object has no attribute 'all'")
      end

      def load(account, card_uris = nil, card_id = nil, with_deleted = nil, opts = {})
        if (card_uris && card_id) || (card_uris.nil? && card_id.nil?)
          raise ArgumentError.new('card_uris and card_id are exclusive parameters. ' \
                             'Please supply one or the other, but not both.')
        end

        params = {}.merge!(opts)

        if with_deleted && TwitterAds::Utils.to_bool(with_deleted)
          params = { with_deleted: true }.merge!(params)
        end

        if card_uris
          params = { card_uris: Array(card_uris).join(',') }.merge!(params)
          resource = FETCH_URI % { account_id: account.id }
          request = Request.new(account.client, :get, resource, params: params)
          return Cursor.new(self.class, request, init_with: [account])
        else
          params = { card_id: card_id }.merge!(params)
          resource = FETCH_ID % { account_id: account.id, id: card_id }
          response = Request.new(account.client, :get, resource, params: params).perform
          return from_response(response.body[:data])
        end
      end

      def reload!
        load(@account, card_id: @id) if @id
      end

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
