# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class AccountMedia

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :deleted, type: :bool, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :media_url, read_only: true

      property :media_id
      property :creative_type
      property :video_id

      RESOURCE_COLLECTION = '/1/accounts/%{account_id}/account_media'.freeze # @api private
      RESOURCE = '/1/accounts/%{account_id}/account_media/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
