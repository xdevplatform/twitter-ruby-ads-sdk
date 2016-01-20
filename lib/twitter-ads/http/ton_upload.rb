# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds

  # Specialized request class for TON API uploads.
  class TONUpload

    DEFAULT_DOMAIN   = 'https://ton.twitter.com'.freeze # @api private
    DEFAULT_RESOURCE = '/1.1/ton/bucket/'.freeze # @api private
    DEFAULT_BUCKET   = 'ta_partner'.freeze # @api private
    DEFAULT_EXPIRE   = (Time.now + 10 * 24 * 60 * 60).httpdate # @api private
    MIN_FILE_SIZE    = 1024 * 1024 * 1 # @api private

    private_constant :DEFAULT_DOMAIN,
                     :DEFAULT_BUCKET,
                     :DEFAULT_EXPIRE,
                     :DEFAULT_RESOURCE,
                     :MIN_FILE_SIZE

    # Creates a new TONUpload object instance.
    #
    # @example
    #   request = TONUpload.new(client, '/path/to/file')
    #
    # @param client [Client] The Client object instance.
    # @param file_path [String] The path to the file to be uploaded.
    #
    # @since 0.3.0
    #
    # @return [TONUpload] The TONUpload request instance.
    def initialize(client, file_path, opts = {})
      @file_path = File.expand_path(file_path)
      unless File.exist?(file_path)
        raise ArgumentError.new("Error! The specified file does not exist. (#{file_path})")
      end

      @file_size = File.size(@file_path)

      @client    = client
      @bucket    = opts.delete(:bucket) || DEFAULT_BUCKET
      @options   = opts
      self
    end

    # Executes the current TONUpload object.
    #
    # @example
    #   request = TONUpload.new(client, '/path/to/file')
    #   request.perform
    #
    # @since 0.3.0
    #
    # @return [String] The upload location provided by the TON API.
    def perform
      if @file_size < MIN_FILE_SIZE
        resource = "#{DEFAULT_RESOURCE}#{@bucket}"
        response = upload(resource, File.read(@file_path))
        response.headers['location'][0]
      else
        response   = init_chunked_upload
        chunk_size = response.headers['x-ton-min-chunk-size'][0].to_i
        location   = response.headers['location'][0]

        File.open(@file_path) do |file|
          bytes_read = 0
          while bytes = file.read(chunk_size)
            bytes_start = bytes_read
            bytes_read += bytes.size
            upload_chunk(location, chunk_size, bytes, bytes_start, bytes_read)
          end
        end

        location
      end
    end

    # Returns an inspection string for the current object instance.
    #
    # @since 0.3.0
    #
    # @return [String] The object instance detail.
    def inspect
      "#<#{self.class.name}:0x#{object_id} bucket=\"#{@bucket}\" file=\"#{@file_path}\">"
    end

    private

    # performs a single chunk upload
    def upload(resource, bytes)
      headers = {
        'x-ton-expires'  => DEFAULT_EXPIRE,
        'content-length' => @file_size,
        'content-type'   => content_type
      }
      TwitterAds::Request.new(
        @client, :post, resource, domain:  DEFAULT_DOMAIN, headers: headers, body: bytes).perform
    end

    # initialization for a multi-chunk upload
    def init_chunked_upload
      headers = {
        'x-ton-content-type'   => content_type,
        'x-ton-content-length' => @file_size,
        'x-ton-expires'        => DEFAULT_EXPIRE,
        'content-length'       => 0,
        'content-type'         => content_type
      }
      resource = "#{DEFAULT_RESOURCE}#{@bucket}?resumable=true"
      TwitterAds::Request.new(
        @client, :post, resource, domain: DEFAULT_DOMAIN, headers: headers).perform
    end

    # uploads a single chunk of a multi-chunk upload
    def upload_chunk(resource, chunk_size, bytes, bytes_start, bytes_read)
      headers = {
        'content-type'   => content_type,
        'content-length' => [chunk_size, @file_size - bytes_read].min,
        'content-range'  => "bytes #{bytes_start}-#{bytes_read - 1}/#{@file_size}"
      }
      TwitterAds::Request.new(
        @client, :put, resource, domain: DEFAULT_DOMAIN, headers: headers, body: bytes).perform
    end

    def content_type
      @content_type ||= begin
        extension = File.extname(@file_path).downcase
        if extension == '.csv'
          'text/csv'
        elsif extension == '.tsv'
          'text/tab-separated-values'
        else
          'text/plain'
        end
      end
    end

  end

end
