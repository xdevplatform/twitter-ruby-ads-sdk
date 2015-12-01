# Copyright (C) 2015 Twitter, Inc.

module TwitterAds

  # Specialized request class for TON API uploads.
  class TONUpload

    DEFAULT_DOMAIN   = 'https://ton.twitter.com' # @api private
    DEFAULT_RESOURCE = '/1.1/ton/bucket/' # @api private
    DEFAULT_BUCKET   = 'ta_partner' # @api private
    MIN_FILE_SIZE    = 1024 * 1024 * 1 # @api private

    private_constant :DEFAULT_DOMAIN,
                     :DEFAULT_BUCKET,
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
    def perform(_opts = {})
      if @file_size < MIN_FILE_SIZE
        headers = {
          'x-ton-expires'        => (Time.now + 10 * 24 * 60 * 60).httpdate,
          'content-length'       => @file_size,
          'content-type'         => content_type
        }
        resource = "#{DEFAULT_RESOURCE}#{@bucket}"
        response = TwitterAds::Request.new(@client,
                                           :post,
                                           resource,
                                           domain:  DEFAULT_DOMAIN,
                                           headers: headers,
                                           body:    File.read(@file_path)
                                          ).perform

        location   = response.headers['location'][0]
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
      end

      location
    end

    # Returns an inspection string for the current object instance.
    #
    # @since 0.3.0
    #
    # @return [String] The object instance detail.
    def inspect
      str = "#<#{self.class.name}:0x#{object_id}"
      str << " bucket=\"#{@bucket}\"" if @bucket
      str << " file=\"#{@file_path}\"" if @file
      str << '>'
    end

    private

    def init_chunked_upload
      headers = {
        'x-ton-content-type'   => content_type,
        'x-ton-content-length' => File.size(@file_path),
        'x-ton-expires'        => (Time.now + 10 * 24 * 60 * 60).httpdate,
        'content-length'       => 0,
        'content-type'         => content_type
      }
      resource = "#{DEFAULT_RESOURCE}#{@bucket}?resumable=true"
      TwitterAds::Request.new(
        @client, :post, resource, domain: DEFAULT_DOMAIN, headers: headers).perform
    end

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
        extension = File.extname(@file_path)
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
