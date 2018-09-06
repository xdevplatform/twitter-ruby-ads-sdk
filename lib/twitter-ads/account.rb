# frozen_string_literal: true
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

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" +
                          'accounts'.freeze # @api private
    RESOURCE            = "/#{TwitterAds::API_VERSION}/" +
                          'accounts/%{id}'.freeze # @api private
    FEATURES            = "/#{TwitterAds::API_VERSION}/" +
                          'accounts/%{id}/features'.freeze # @api private
    SCOPED_TIMELINE     = "/#{TwitterAds::API_VERSION}/" +
                          'accounts/%{id}/scoped_timeline'.freeze # @api private
    AUTHENTICATED_USER_ACCESS = "/#{TwitterAds::API_VERSION}/" +
                                'accounts/%{id}/authenticated_user_access'.freeze # @api private

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
        resource = RESOURCE % { id: id }
        response = Request.new(client, :get, resource).perform
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
        request = Request.new(client, :get, RESOURCE_COLLECTION, params: opts)
        Cursor.new(self, request, init_with: [client])
      end

    end

    # Returns an inspection string for the current object instance.
    #
    # @return [String] The object instance detail.
    def inspect
      str = String.new("#<#{self.class.name}:0x#{object_id}")
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
      resource = FEATURES % { id: @id }
      response = Request.new(client, :get, resource).perform
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

    # Returns a collection of promoted tweets available to the current account.
    #
    # @param id [String] The PromotedTweet ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [String] :line_item_ids Scope the result to collection of line item IDs.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @return A Cursor or object instance.
    #
    # @since 1.0.0
    def promotable_tweets(id = nil, opts = {})
      load_resource(Creative::PromotedTweet, id, opts)
    end

    # Returns a collection of promoted accounts available to the current account.
    #
    # @param id [String] The PromotedAccount ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [String] :line_item_ids Scope the result to collection of line item IDs.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @return A Cursor or object instance.
    #
    # @since 1.0.0
    def promotable_accounts(id = nil, opts = {})
      load_resource(Creative::PromotedAccount, id, opts)
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

    # Returns a collection of app lists available to the current account.
    #
    # @param id [String] The AppList ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @since 0.2.0
    #
    # @return A list or object instance.
    def app_lists(id = nil, opts = {})
      load_resource(AppList, id, opts)
    end

    # Returns a collection of tailored audiences available to the current account.
    #
    # @param id [String] The TailoredAudience ID value.
    # @param opts [Hash] A Hash of extended options.
    # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
    # @option opts [String] :sort_by The object param to sort the API response by.
    #
    # @since 0.3.0
    #
    # @return A Cursor or object instance.
    def tailored_audiences(id = nil, opts = {})
      load_resource(TailoredAudience, id, opts)
    end

    # Returns the most recent promotable Tweets created by one or more specified Twitter users.
    #
    # @param ids [Array] An Array of Twitter user IDs.
    # @param opts [Hash] A Hash of extended options.
    #
    # @return [Array] An Array of Tweet objects.
    #
    # @since 0.2.3
    def scoped_timeline(ids, opts = {})
      ids      = ids.join(',') if ids.is_a?(Array)
      params   = { user_ids: ids }.merge!(opts)
      resource = SCOPED_TIMELINE % { id: @id }
      request  = Request.new(client, :get, resource, params: params)
      response = request.perform
      response.body[:data]
    end

    def authenticated_user_access
      params = {}
      resource = AUTHENTICATED_USER_ACCESS % { id: @id }
      request  = Request.new(client, :get, resource, params: params)
      response = request.perform
      response.body[:data]
    end

    def web_event_tags(id = nil, opts = {})
      load_resource(WebEventTag, id, opts)
    end

    def app_event_tags(id = nil, opts = {})
      load_resource(AppEventTag, id, opts)
    end

    private

    def load_resource(klass, id = nil, opts = {})
      validate_loaded
      id ? klass.load(self, id, opts) : klass.all(self, opts)
    end

    def validate_loaded
      raise ArgumentError.new(
        "Error! #{self.class} object not yet initialized, " \
        "call #{self.class}.load first") unless @id
    end

  end
end
