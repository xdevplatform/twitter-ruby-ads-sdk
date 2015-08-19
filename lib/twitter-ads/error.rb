# Copyright (C) 2015 Twitter, Inc.

module TwitterAds

  class Error < StandardError

    attr_reader :response, :details

    def initialize(object)
      @response = object
      @details  = object.body[:errors] if object.body[:errors]
      self
    end

    def inspect
      str = "#<#{self.class.name}:0x#{object_id}"
      str << " code=#{@response.code}" if @response && @response.code
      str << " details=\"#{@details}\"" if @details
      str << '>'
    end
    alias_method :to_s, :inspect

    class << self

      ERRORS = {
        400 => 'TwitterAds::BadRequest',
        401 => 'TwitterAds::NotAuthorized',
        403 => 'TwitterAds::Forbidden',
        404 => 'TwitterAds::NotFound',
        429 => 'TwitterAds::RateLimit',
        500 => 'TwitterAds::ServerError',
        503 => 'TwitterAds::ServiceUnavailable'
      }

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

  class ServiceUnavailable < ServerError
    attr_reader :retry_after

    def initialize(object)
      super object
      if object.headers['retry-after']
        @retry_after = object.headers['retry-after']
      end
      self
    end
  end

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
      @reset_at = object.rate_limit_reset
      self
    end
  end

end
