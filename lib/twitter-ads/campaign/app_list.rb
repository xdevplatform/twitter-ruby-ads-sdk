# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  class AppList

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :apps, read_only: true
    property :name, read_only: true

    RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/app_lists' # @api private
    RESOURCE            = "/#{TwitterAds::API_VERSION}/" \
                          'accounts/%{account_id}/app_lists/%{id}' # @api private

    def initialize(account)
      @account = account
      self
    end

    # Creates a new App List
    #
    # @param name [String] The name for the app list to be created.
    # @param ids [String] String or String Array of app IDs.
    #
    # @return [self] Returns the instance refreshed from the API
    def create(name, *ids)
      resource = self.class::RESOURCE_COLLECTION % { account_id: account.id }
      params = to_params.merge!(app_store_identifiers: ids.join(','), name: name)
      response = Request.new(account.client, :post, resource, params: params).perform
      from_response(response.body[:data])
    end

    def apps
      reload! if @id && !@apps
      @apps
    end
  end
end
