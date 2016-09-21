# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class TargetingCriteria

    include TwitterAds::DSL
    include TwitterAds::Persistence
    include TwitterAds::Resource::InstanceMethods

    attr_reader :account

    property :id, read_only: true
    property :name, read_only: true
    property :localized_name, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    property :line_item_id
    property :targeting_type
    property :targeting_value
    property :tailored_audience_expansion, type: :bool
    property :tailored_audience_type
    property :location_type

    RESOURCE_COLLECTION = '/1/accounts/%{account_id}/targeting_criteria'.freeze # @api private
    RESOURCE            = '/1/accounts/%{account_id}/targeting_criteria/%{id}'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end

    class << self

      # Returns a Cursor instance for a given resource.
      #
      # @param account [Account] The Account object instance.
      # @param line_item_id [String] The line item ID string.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
      # @option opts [String] :sort_by The object param to sort the API response by.
      #
      # @return [Cursor] A Cusor object ready to iterate through the API response.
      #
      # @since 0.3.1
      # @see Cursor
      # @see https://dev.twitter.com/ads/basics/sorting Sorting
      def all(account, line_item_id, opts = {})
        params = { line_item_id: line_item_id }.merge!(opts)
        resource = RESOURCE_COLLECTION % { account_id: account.id }
        request = Request.new(account.client, :get, resource, params: params)
        Cursor.new(self, request, init_with: [account])
      end

      # Returns an object instance for a given resource.
      #
      # @param account [Account] The Account object instance.
      # @param id [String] The ID of the specific object to be loaded.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
      # @option opts [String] :sort_by The object param to sort the API response by.
      #
      # @return [self] The object instance for the specified resource.
      #
      # @since 0.3.1
      def load(account, id, opts = {})
        params   = { with_deleted: true }.merge!(opts)
        resource = RESOURCE % { account_id: account.id, id: id }
        response = Request.new(account.client, :get, resource, params: params).perform
        new(account).from_response(response.body[:data])
      end

    end

  end
end
