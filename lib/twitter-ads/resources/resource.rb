# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Resource

    def self.included(klass)
      klass.send :include, InstanceMethods
      klass.extend ClassMethods
    end

    module InstanceMethods

      # Reloads all attributes for the current object instance from the API.
      #
      # @example
      #   object.reload!
      #
      # Note: calls to this method dispose of any unsaved data on the object instance.
      #
      # @param opts [Hash] An optional Hash of extended request options.
      #
      # @return [self] The reloaded instance of the current object.
      #
      # @since 0.1.0
      def reload!(opts = {})
        return self unless id
        params   = { with_deleted: true }.merge!(opts)
        resource = self.class::RESOURCE % { account_id: account.id, id: id }
        response = Request.new(account.client, :get, resource, params: params).perform
        from_response(response.body[:data])
      end

      # Returns an inspection string for the current object instance.
      #
      # @example
      #   object.inspect
      #
      # @return [String] The object instance details.
      #
      # @since 0.1.0
      def inspect
        str = +"#<#{self.class.name}:0x#{object_id}"
        str << " id=\"#{@id}\"" if @id
        str << ' deleted="true"' if @deleted
        str << '>'
      end

    end

    module ClassMethods

      # Returns a Cursor instance for a given resource.
      #
      # @param account [Account] The Account object instance.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Boolean] :with_deleted Indicates if deleted items should be included.
      # @option opts [String] :sort_by The object param to sort the API response by.
      #
      # @return [Cursor] A Cusor object ready to iterate through the API response.
      #
      # @since 0.1.0
      # @see Cursor
      # @see https://dev.twitter.com/ads/basics/sorting Sorting
      def all(account, opts = {})
        resource = self::RESOURCE_COLLECTION % { account_id: account.id }
        request = Request.new(account.client, :get, resource, params: opts)
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
      # @since 0.1.0
      def load(account, id, opts = {})
        params   = { with_deleted: true }.merge!(opts)
        resource = self::RESOURCE % { account_id: account.id, id: id }
        response = Request.new(account.client, :get, resource, params: params).perform
        new(account).from_response(response.body[:data])
      end

    end

  end
end
