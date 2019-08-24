# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds

  class Error < StandardError

    attr_reader :code, :headers, :response, :details

    def initialize(*args)
      if args.size == 1 && args[0].respond_to?(:body) && args[0].respond_to?(:code)
        @response = args[0]
        @code     = args[0].code
        @details  = args[0].body[:errors] if args[0].body.is_a?(Hash) && args[0].body[:errors]
      elsif args.size == 3
        @response = args[0]
        @details  = args[1]
        @code     = args[2]
      end
      self
    end

    def inspect
      str = +"#<#{self.class.name}:0x#{object_id}"
      str << " code=#{@code}" if @code
      str << " details=\"#{@details}\"" if @details
      str << '>'
    end
    alias to_s inspect

    class << self

      ERRORS = {
        400 => 'TwitterAds::BadRequest',
        401 => 'TwitterAds::NotAuthorized',
        403 => 'TwitterAds::Forbidden',
        404 => 'TwitterAds::NotFound',
        429 => 'TwitterAds::RateLimit',
        500 => 'TwitterAds::ServerError',
        503 => 'TwitterAds::ServiceUnavailable'
      }.freeze

      # Returns an appropriately typed Error object based from an API response.
      #
      # @param object [Hash] The parsed JSON API response.
      #
      # @return [Error] The error object instance.
      #
      # @since 0.1.0
      # @api private
      def from_response(object)
        return class_eval(ERRORS[object.code]).new(object) if ERRORS.key?(object.code)
        new(object) # fallback, unknown error
      end

    end

  end

  # Server Errors (5XX)
  class ServerError < Error; end
  class ServiceUnavailable < ServerError; end

  # Client Errors (4XX)
  class ClientError < Error; end
  class NotAuthorized < ClientError; end
  class Forbidden < ClientError; end
  class NotFound < ClientError; end
  class BadRequest < ClientError; end

  class RateLimit < ClientError
    attr_reader :reset_at

    def initialize(object)
      super object
      header = object.headers.fetch('x-account-rate-limit-reset', nil) ||
               object.headers.fetch('x-rate-limit-reset', nil)
      @reset_at = header.first.to_i
      self
    end
  end

end
