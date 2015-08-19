# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class Account

    include TwitterAds::DSL

    attr_reader :client

    property :id, read_only: true
    property :name, read_only: true
    property :salt, read_only: true
    property :timezone, read_only: true
    property :timezone_switch_at, type: :time, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    RESOURCE_COLLECTION = '/0/accounts' # @api private
    RESOURCE            = '/0/accounts/%{id}' # @api private

    def initialize(client)
      @client = client
      self
    end

    class << self

      # Load a specific Account object by ID.
      #
      # @example
      #   account = Account.load(client, '7o4em', with_deleted: true)
      #
      # @param client [Client] The Client object instance.
      # @param id [String] The Account ID value.
      #
      # @return [Account] The Account object instance.
      #
      # @since 0.1.0
      def load(client, id)
        response = Request.new(client, :get, "/0/accounts/#{id}").perform
        new(client).from_response(response.body[:data])
      end

      # Fetches all available Accounts.
      #
      # @example
      #   account = Account.all(client, with_deleted: true, sort_by: 'updated_at-desc')
      #
      # @param client [Client] The Client object instance.
      # @param opts [Hash] A Hash of extended options.
      # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
      # @option opts [String] :sort_by The object param to sort the API response by.
      #
      # @return [Cursor] A Cursor for the API results.
      #
      # @since 0.1.0
      # @see https://dev.twitter.com/ads/basics/sorting Sorting
      def all(client, opts = {})
        request = Request.new(client, :get, '/0/accounts', params: opts)
        Cursor.new(self, request, init_with: [client])
      end

    end

    # Returns an inspection string for the current object instance.
    #
    # @return [String] The object instance detail.
    def inspect
      str = "#<#{self.class.name}:0x#{object_id}"
      str << " id=\"#{@id}\"" if @id
      str << '>'
    end

    # Returns a collection of features available to the current account.
    #
    # @return [Array] The list of features enabled for the account.
    #
    # @since 0.1.0
    def features
      validate_loaded
      response = Request.new(client, :get, "/0/accounts/#{id}/features").perform
      response.body[:data]
    end

    # Returns a collection of promotable users available to the current account.
    #
    # @param id [String] The PromotableUser ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @return A Cursor or object instance.
    #
    # @since 0.1.0
    def promotable_users(id = nil, opts = {})
      load_resource(PromotableUser, id, opts)
    end

    # Returns a collection of funding instruments available to the current account.
    #
    # @param id [String] The FundingInstrument ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @return A Cursor or object instance.
    #
    # @since 0.1.0
    def funding_instruments(id = nil, opts = {})
      load_resource(FundingInstrument, id, opts)
    end

    # Returns a collection of campaigns available to the current account.
    #
    # @param id [String] The Campaign ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @return A Cursor or object instance.
    #
    # @since 0.1.0
    def campaigns(id = nil, opts = {})
      load_resource(Campaign, id, opts)
    end

    # Returns a collection of line items available to the current account.
    #
    # @param id [String] The LineItem ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @return A Cursor or object instance.
    #
    # @since 0.1.0
    def line_items(id = nil, opts = {})
      load_resource(LineItem, id, opts)
    end

    private

    def load_resource(klass, id = nil, opts = {})
      validate_loaded
      id ? klass.load(self, id) : klass.all(self, opts)
    end

    def validate_loaded
      raise ArgumentError.new(
        "Error! #{self.class} object not yet initialized, " \
        "call #{self.class}.load first") unless @id
    end

  end
end
