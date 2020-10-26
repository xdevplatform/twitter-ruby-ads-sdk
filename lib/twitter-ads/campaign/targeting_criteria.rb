# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class TargetingCriteria

    include TwitterAds::DSL
    include TwitterAds::Persistence
    include TwitterAds::Resource::InstanceMethods
    include TwitterAds::Batch

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
    property :operator_type
    property :tailored_audience_expansion, type: :bool
    property :location_type

    # sdk only
    property :to_delete, type: :bool

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/targeting_criteria' # @api private
    RESOURCE_BATCH      = "/#{TwitterAds::API_VERSION}/" \
                          'batch/accounts/%{account_id}/targeting_criteria' # @api private
    RESOURCE            = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/targeting_criteria/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end

    class << self

      # Returns a Cursor instance for a given resource.
      #
      # @param account [Account] The Account object instance.
      # @param line_item_ids [String] A String or String array of Line Item IDs.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
      # @option opts [String] :sort_by The object param to sort the API response by.
      #
      # @return [Cursor] A Cusor object ready to iterate through the API response.
      #
      # @since 0.3.1
      # @see Cursor
      # @see https://dev.twitter.com/ads/basics/sorting Sorting
      def all(account, line_item_ids, opts = {})
        params = { line_item_ids: Array(line_item_ids).join(',') }.merge!(opts)
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
