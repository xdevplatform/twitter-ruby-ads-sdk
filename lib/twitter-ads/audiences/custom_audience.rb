# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class CustomAudience

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    property :name
    property :list_type

    property :audience_size, read_only: true
    property :audience_type, read_only: true
    property :partner_source, read_only: true
    property :reasons_not_targetable, read_only: true
    property :targetable, type: :bool, read_only: true
    property :targetable_types, read_only: true
    property :permission_level, read_only: true
    property :owner_account_id, read_only: true

    RESOURCE_COLLECTION  = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/custom_audiences' # @api private
    RESOURCE             = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/custom_audiences/%{id}' # @api private
    RESOURCE_USERS       = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/custom_audiences/' \
                           '%{id}/users' # @api private

    LIST_TYPES = %w(
      EMAIL
      DEVICE_ID
      TWITTER_ID
      HANDLE
      PHONE_NUMBER
    ).freeze

    OPERATIONS = %w(
      ADD
      REMOVE
      REPLACE
    ).freeze

    def initialize(account)
      @account = account
      self
    end

    class << self

      # Creates a new custom audience.
      #
      # @example
      #   audience = CustomAudience.create(account, 'my list')
      #
      # @param account [Account] The account object instance.
      # @param name [String] The custom audience name.
      #
      # @since 4.0
      #
      # @return [CustomAudience] The newly created custom audience instance.
      def create(account, name)
        audience = new(account)
        params = { name: name }
        resource = RESOURCE_COLLECTION % { account_id: account.id }
        response = Request.new(account.client, :post, resource, params: params).perform
        audience.from_response(response.body[:data])
      end

    end

    # Deletes the current custom audience instance.
    #
    # @example
    #   audience.delete!
    #
    # Note: calls to this method are destructive and irreverisble.
    #
    # @since 0.3.0
    #
    # @return [self] Returns the custom audience instance refreshed from the API.
    def delete!
      resource = RESOURCE % { account_id: account.id, id: id }
      response = Request.new(account.client, :delete, resource).perform
      from_response(response.body[:data])
    end

    # This is a private API and requires allowlisting from Twitter.
    #
    # This endpoint will allow partners to add, update and remove users from a given
    # custom_audience_id.
    # The endpoint will also accept multiple user identifier types per user as well.
    #
    # @example
    #   custom_audience.users(
    #     account,
    #     [
    #       {
    #         "operation_type": "Update",
    #         "params": {
    #           "effective_at": "2018-05-15T00:00:00Z",
    #           "expires_at": "2019-01-01T07:00:00Z",
    #           "users": [
    #             {
    #               "twitter_id": [
    #                 "4798b8bbdcf6f2a52e527f46a3d7a7c9aefb541afda03af79c74809ecc6376f3"
    #               ]
    #             }
    #           ]
    #         }
    #       }
    #     ]
    #   )
    #
    # @param params [JSON object] A hash containing the list of users to be added/removed/updated
    #
    # @since 4.0
    #
    # @return success_count, total_count
    def users(params)
      resource = RESOURCE_USERS % { account_id: account.id, id: id }
      headers = { 'Content-Type' => 'application/json' }
      response = TwitterAds::Request.new(account.client,
                                         :post,
                                         resource,
                                         headers: headers,
                                         body: params.to_json).perform
      success_count = response.body[:data][:success_count]
      total_count = response.body[:data][:total_count]

      [success_count, total_count]
    end

    # Retrieves the entites targeting the current tailored audience instance.
    #
    # @example
    #   audience.targeted(with_active=true)
    #
    # @param with_active [bool] Include active/inactive
    #
    # @since 8.0.0
    #
    # @return [self] Returns a Cursor instance of the targeted entities.
    def targeted(opts = {})
      validate_loaded
      params = {}.merge!(opts)
      TargetedTailoredAudience.load(account, id, params)
    end

    def validate_loaded
      raise ArgumentError.new(
        "Error! #{self.class} object not yet initialized, " \
        "call #{self.class}.load first") if id.nil?
    end
  end

  class TargetedTailoredAudience

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    # read-only
    property :campaign_id, read_only: true
    property :campaign_name, read_only: true
    property :line_items, read_only: true

    RESOURCE_TARGETED = "/#{TwitterAds::API_VERSION}/" \
                        'accounts/%{account_id}/tailored_audiences/%{id}/targeted' # @api private

    def initialize(account)
      @account = account
      self
    end

    class << self

      def load(account, tailored_audience_id, params)
        resource = RESOURCE_TARGETED % { account_id: account.id, id: tailored_audience_id }
        request = TwitterAds::Request.new(account.client,
                                          :get,
                                          resource,
                                          params: params)
        Cursor.new(self, request, init_with: [account])
      end
    end
  end

  class CustomAudiencePermission

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    # read-only
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    property :id
    property :custom_audience_id
    property :granted_account_id
    property :permission_level

    RESOURCE_COLLECTION  = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/custom_audiences/' \
                           '%{custom_audience_id}/permissions' # @api private
    RESOURCE             = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/custom_audiences/' \
                           '%{custom_audience_id}/permissions/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end

    class << self

      # Retrieve details for some or
      # all permissions associated with the specified custom audience.
      #
      # @exapmle
      #   permissions = CustomAudiencePermission.all(account, '36n4f')
      #
      # @param account [Account] The account object instance.
      # @param custom_audience_id [String] The custom audience id.
      #
      # @since 5.2.0
      #
      # @return [CustomAudiencePermission] The custom audience permission instance.
      def all(account, custom_audience_id, opts = {})
        params = {}.merge!(opts)
        resource = RESOURCE_COLLECTION % {
          account_id: account.id,
          custom_audience_id: custom_audience_id
        }
        request = Request.new(account.client, :get, resource, params: params)
        Cursor.new(self, request, init_with: [account])
      end

    end

    # Saves or updates the current object instance
    # depending on the presence of `object.custom_audience_id`.
    #
    # @exapmle
    #   object.save
    #
    # @since 5.2.0
    #
    # @return [self] Returns the instance refreshed from the API.
    def save
      resource = RESOURCE_COLLECTION % {
        account_id: account.id,
        custom_audience_id: custom_audience_id
      }
      params = to_params
      response = Request.new(account.client, :post, resource, params: params).perform
      from_response(response.body[:data])
    end

    # Deletes the current or specified custom audience permission.
    #
    # @example
    #   object.delete!
    #
    # Note: calls to this method are destructive and irreverisble.
    #
    # @since 5.2.0
    #
    # @return [self] Returns the instance refreshed from the API.
    def delete!
      resource = RESOURCE % {
        account_id: account.id,
        custom_audience_id: custom_audience_id,
        id: @id
      }
      response = Request.new(account.client, :delete, resource).perform
      from_response(response.body[:data])
    end
  end
end
