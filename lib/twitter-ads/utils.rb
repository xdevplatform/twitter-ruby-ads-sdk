# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Utils

    class << self

      # Helper to convert objects into boolean values.
      #
      # @param object [Object] The object to be converted.
      #
      # @return [Boolean] The boolean result.
      #
      # @api private
      # @since 0.1.0
      def to_bool(object)
        (object.to_s.downcase == 'false') ? false : !!object
      end

      # Helper to convert a time object according to a given granularity level.
      #
      # @param time [Time] A valid Time instance.
      # @param granularity [Symbol] A symbol representing the desired granuarlity (eg. :hour).
      #
      # @return [Time] The formatted Time instance.
      #
      # @api private
      # @since 0.1.0
      def to_time(time, granularity = nil, utc_offset = nil)
        return time.iso8601 unless granularity
        if granularity == :hour
          Time.new(time.year, time.month, time.day, time.hour, 0, 0, utc_offset).iso8601
        elsif granularity == :day
          Time.new(time.year, time.month, time.day, 0, 0, 0, utc_offset).iso8601
        else
          time.iso8601
        end
      end

      # Converts key names to symbols on a given object.
      #
      # @param object [Object] The object to be converted.
      #
      # @return [Object] The symbolized, converted object.
      #
      # @api private
      # @since 0.1.0
      def symbolize!(object)
        if object.is_a?(Array)
          object.each_with_index { |value, index| object[index] = symbolize!(value) }
        elsif object.is_a?(Hash)
          object.keys.each { |key| object[key.to_sym] = symbolize!(object.delete(key)) }
        end
        object
      end

      # Creates a deprecation message.
      #
      # @param name [String] The name of the object or method being deprecated.
      # @param replacement [String] The name of the new object or method (optional).
      # @param refer [String] HTTP address with supporting information (optional).
      #
      # @api private
      # @since 0.3.2
      def deprecated(name, opts = {})
        message = +"[DEPRECATED] #{name} has been deprecated"
        message += opts[:replacement] ? " (please use #{opts[:replacement]})." : '.'
        message += " Please see #{opts[:refer]} for more info." if opts[:refer]
        warn message
      end

    end

  end
end
