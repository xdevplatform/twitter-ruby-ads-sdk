# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Persistence

    # Saves or updates the current object instance depending on the presence of `object.id`.
    #
    # @example
    #   object.save
    #
    # @return [self] Returns the instance refreshed from the API.
    #
    # @since 0.1.0
    def save
      if @id
        resource = self.class::RESOURCE % { account_id: account.id, id: id }
        response = Request.new(account.client, :put, resource, params: to_params).perform
      else
        resource = self.class::RESOURCE_COLLECTION % { account_id: account.id }
        response = Request.new(account.client, :post, resource, params: to_params).perform
      end
      from_response(response.body[:data])
    end

    # Deletes the current object instance depending on the presence of `object.id`.
    #
    # @example
    #   object.delete!
    #
    # Note: calls to this method are destructive and irreverisble for most API objects.
    #
    # @return [self] Returns the instance refreshed from the API.
    #
    # @since 0.1.0
    def delete!
      resource = self.class::RESOURCE % { account_id: account.id, id: id }
      response = Request.new(account.client, :delete, resource).perform
      from_response(response.body[:data])
    end

  end
end
