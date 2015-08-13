# Copyright (C) 2015 Twitter, Inc.

module TwitterAds

  # Generic container for API requests.
  class Request

    attr_reader :client, :method, :resource, :options

    HTTP_METHOD = {
      get:    Net::HTTP::Get,
      post:   Net::HTTP::Post,
      put:    Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }

    API_BASE  = 'https://ads-api.twitter.com'

    private_constant :API_BASE, :HTTP_METHOD

    # Creates a new Request object instance.
    #
    # @example
    #   request = Request.new(@client, '/0/accounts', :get)
    #
    # @param client [Client] [description]
    # @param method [Symbol] [description]
    # @param resource [String] [description]
    # @param opts={} [Hash] [description]
    #
    # @since 0.1.0
    #
    # @return [Request] The Request object instance.
    def initialize(client, method, resource, opts = {})
      @client   = client
      @method   = method
      @resource = resource
      @options  = opts
      self
    end

    # Executes the current Request object.
    #
    # @example
    #   request  = Request.new(client, :get, '/0/accounts')
    #   response = request.perform
    #
    # @since  1.0.0
    #
    # @return [Response] The Response object instance generated by the Request.
    def perform
      response = oauth_request
      raise TwitterAds::Error.from_response(response) unless response.code < 400
      response
    end

    private

    def oauth_request
      request  = http_request
      consumer = OAuth::Consumer.new(@client.consumer_key, @client.consumer_secret, site: API_BASE)
      token    = OAuth::AccessToken.new(consumer, @client.access_token, @client.access_token_secret)
      request.oauth!(consumer.http, consumer, token)
      response = consumer.http.request(request)
      Response.new(response.code, response.each {}, response.body)
    end

    def http_request
      request_url = @resource
      request_url += "?#{URI.encode_www_form(@options[:params])}" if @options[:params]
      request = HTTP_METHOD[@method].new(request_url)

      @options[:headers].each { |header, value| request[header] = value } if @options[:headers]
      request.body = @options[:body] if @options[:body]

      request['User-Agent'] = "twitter-ads version: #{TwitterAds::VERSION} " \
                              "platform: #{RUBY_ENGINE} #{RUBY_VERSION} (#{RUBY_PLATFORM})"
      request
    end
  end

end
