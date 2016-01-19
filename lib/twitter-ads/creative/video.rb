# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class Video

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :tweeted, type: :bool, read_only: true
      property :ready_to_tweet, type: :bool, read_only: true
      property :duration, read_only: true
      property :reasons_not_servable, read_only: true
      property :preview_url, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true

      property :title
      property :description
      property :video_media_id

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/videos'.freeze # @api private
      RESOURCE            = '/0/accounts/%{account_id}/videos/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end

# TODO: legacy namespace support, to be removed in v1.0.0 (next major)
TwitterAds::Video = TwitterAds::Creative::Video
