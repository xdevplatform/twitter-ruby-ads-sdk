# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds

  # Generic container for API responses.
  class Response

    attr_reader :code,
                :headers,
                :raw_body,
                :body

    # Creates a new Response object instance.
    #
    # @example
    #   response = Response.new(code, headers, body)
    #
    # @param code [String] The HTTP status code.
    # @param headers [Hash] A Hash object containing HTTP response headers.
    # @param body [String] The response body.
    #
    # @since 0.1.0
    #
    # @return [Response] The Response object instance.
    def initialize(code, headers, body)
      @code     = code.to_i
      @headers  = headers
      @raw_body = body

      # handle non-JSON responses
      begin
        @body = TwitterAds::Utils.symbolize!(MultiJson.load(body))
      rescue MultiJson::ParseError
        @body = raw_body
      end

      self
    end

    # Returns an inspection string for the current Response instance.
    #
    # @example
    #   response.inspect
    #
    # @since 0.1.0
    #
    # @return [String] The inspection string.
    def inspect
      "#<#{self.class.name}:0x#{object_id} code=\"#{@code}\" error=\"#{error?}\">"
    end

    # Helper method for determining if the current Response contains an error.
    #
    # @return [Boolean] True or false indicating if this Response contains an error.
    def error?
      @error ||= (@code >= 400 && @code <= 599)
    end

  end

end
