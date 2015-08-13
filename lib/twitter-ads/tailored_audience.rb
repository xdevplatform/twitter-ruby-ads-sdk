# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class TailoredAudience

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence

    attr_reader :account

    property :id, read_only: true
    property :targetable, type: :bool, read_only: true
    property :targetable_types, read_only: true
    property :audience_type, read_only: true
    property :reasons_not_targetable, read_only: true
    property :partner_source, read_only: true
    property :audience_size, read_only: true
    property :deleted, type: :bool, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true

    property :name
    property :list_type

    RESOURCE_COLLECTION = '/0/accounts/%{account_id}/tailored_audiences' # @api private
    RESOURCE            = '/0/accounts/%{account_id}/tailored_audiences/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end

    # Uploads a file of changes to the TON API then queues it for processing.
    #
    # @example
    #   audience = TailoredAudience.load(account, '7o4em')
    #   audience.changes('/path/to/file')
    #
    # @param file_path [String] The path to the file to be uploaded.
    #
    # @return [TailoredAudience] The updated TailoredAudience instance.
    #
    # @since 0.1.0
    #
    # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/tailored_audience_change Tailored Audience Changes
    # @see https://dev.twitter.com/ads/audiences/file-data Tailored Audience File Data
    def changes(file_path)
      raise NotImplementedError.new
    end

    class << self

      # Uploads a new file to the TON API then queues it for processing.
      #
      # @example
      #   audience = TailoredAudience.upload(account, :twitter_id, '/path/to/file')
      #
      # @param account [Account] The Account object instance.
      # @param type [Symbol] The list type to be processed (eg. :email).
      # @param file_path [String] The path to the file to be uploaded.
      #
      # @return [TailoredAudience] A new TailoredAudience instance.
      #
      # @since 0.1.0
      #
      # @see https://dev.twitter.com/ads/reference/post/accounts/%3Aaccount_id/tailored_audiences Tailored Audiences
      # @see https://dev.twitter.com/ads/audiences/file-data Tailored Audience File Data
      def upload(account, type, file_path)
        raise NotImplementedError.new
      end

      # Uploads a  file to the TON API then queues it for global opt-out processing.
      #
      # @example
      #   TailoredAudience.opt_out(account, :device_id, /path/to/file)
      #
      # @param account [Account] The Account object instance.
      # @param type [Symbol] The list type to be processed (eg. :email).
      # @param file_path [String] The path to the file to be uploaded.
      #
      # @return [Boolean] A boolean value indicating operation success.
      #
      # @since 0.1.0
      #
      # @see https://dev.twitter.com/ads/reference/put/accounts/%3Aaccount_id/tailored_audiences/global_opt_out Tailored Audiences Opt-Out
      # @see https://dev.twitter.com/ads/audiences/file-data Tailored Audience File Data
      def opt_out(account, type, file_path)
        raise NotImplementedError.new
      end

    end

  end
end
