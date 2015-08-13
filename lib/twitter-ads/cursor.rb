# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class Cursor

    include ::Enumerable

    def initialize(klass, request, opts = {})
      @klass      = klass
      @client     = request.client
      @method     = request.method
      @resource   = request.resource
      @options    = opts.merge!(request.options)
      @collection = []
      from_response(request.perform)
      self
    end

    def each(offset = 0)
      return to_enum(:each, offset) unless block_given?
      @collection[offset..-1].each { |element| yield(element) }
      unless exhausted?
        offset = [@collection.size, offset].max
        perform_next
        each(offset, &Proc.new)
      end
      self
    end

    # Determines whether or not the current Cusor instance has been exhausted.
    #
    # @return [Boolean] A boolean value indicating Cursor status.
    #
    # @since 0.1.0
    def exhausted?
      !@next_cursor
    end

    # Returns the full size of the cursor (even if not exhausted).
    #
    # @return [Integer] The Cursor count / size.
    #
    # @since 0.1.0
    def count
      @total_count
    end
    alias_method :size, :count

    # Returns an inspection string for the current Cursor instance.
    #
    # @example
    #   cursor.inspect
    #
    # @since 0.1.0
    #
    # @return [String] The inspection string.
    def inspect
      "#<#{self.class.name}:0x#{object_id} count=#{size} exhausted=#{exhausted?}>"
    end

    private

    def perform_next
      return unless @next_cursor
      opts = @options.dup
      opts[:params] = opts.fetch(:params, {}).merge!(cursor: @next_cursor)
      from_response(Request.new(@client, @method, @resource, opts).perform)
    end

    def from_response(response)
      @next_cursor = response.body[:next_cursor]
      @total_count ||= response.body[:total_count].to_i
      response.body.fetch(:data, []).each do |object|
        if @klass && @klass.method_defined?(:from_response)
          @collection << @klass.new(
            *@options[:init_with]).from_response(object)
        else
          @collection << object
        end
      end
    end

  end

end
