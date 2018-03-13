# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class AudienceIntelligence

    include TwitterAds::DSL
    include TwitterAds::Resource::InstanceMethods

    attr_reader :account

    # writable
    property :conversation_type
    property :targeting_inputs
    property :audience_definition

    # demographics-only
    property :start_time, type: :time
    property :end_time, type: :time

    # read
    property :operator_type, read_only: true
    property :targeting_type, read_only: true
    property :targeting_value, read_only: true
    property :localized, read_only: true

    RESOURCE_CONVERSATIONS  = "/#{TwitterAds::API_VERSION}/" \
                              'accounts/%{account_id}/audience_intelligence/' \
                              'conversations'.freeze # @api private
    RESOURCE_DEMOGRAPHICS   = "/#{TwitterAds::API_VERSION}/" \
                              'accounts/%{account_id}/audience_intelligence/' \
                              'demographics'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end

    def conversations
      headers = { 'Content-Type' => 'application/json' }
      params = {
        conversation_type: conversation_type,
        audience_definition: audience_definition,
        targeting_inputs: targeting_inputs
      }
      resource = RESOURCE_CONVERSATIONS % { account_id: account.id }
      request = Request.new(account.client, :post, resource, body: params.to_json, headers: headers)
      Cursor.new(self.class, request, init_with: [account])
    end

    def demographics
      headers = { 'Content-Type' => 'application/json' }
      params = {
        audience_definition: audience_definition,
        targeting_inputs: targeting_inputs
      }
      resource = RESOURCE_DEMOGRAPHICS % { account_id: account.id }
      response = Request.new(
        account.client,
        :post,
        resource,
        body: params.to_json,
        headers: headers).perform
      response.body[:data]
      # cannot use cursor here given that the response "keys" are dynmaic based on input values
    end
  end
end
