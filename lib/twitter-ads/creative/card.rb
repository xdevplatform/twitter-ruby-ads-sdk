# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    # Base class for common behavior and shared attributes of all card types.
    # @note: This class should not be instantiated directly.
    class Card

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

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
