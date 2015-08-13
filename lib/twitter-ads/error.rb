# Copyright (C) 2015 Twitter, Inc.

module TwitterAds

  class Error < StandardError

    attr_reader :response, :details

    def initialize(object)
      @response = object
      @details  = object.body[:errors] if object.body[:errors]
      self
    end

    private

    class << self

      # Returns an appropriately typed Error object based from an API response.
      #
      # @param object [Hash] The parsed JSON API response.
      #
      # @return [Error] The error object instance.
      #
      # @since 0.1.0
      # @api private
      def from_response(object)
        error_class = if object.code == 400
          TwitterAds::BadRequest
        elsif object.code == 401
          TwitterAds::NotAuthorized
        elsif object.code == 403
          TwitterAds::Forbidden
        elsif object.code == 404
          TwitterAds::NotFound
        elsif object.code == 429
          TwitterAds::RateLimit
        elsif object.code == 500
          TwitterAds::ServerError
        elsif object.code == 503
          TwitterAds::ServiceUnavailable
        else
          self # fallback, unknown error
        end
        error_class.new(object)
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
