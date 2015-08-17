# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Utils

    class << self

      # Helper to convert objects into boolean values.
      #
      # @param object [Object] The object to be converted.
      #
      # @return [Boolean] The boolean result.
      #
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
      # @since 0.1.0
      def to_time(time, granularity = nil)
        return time.iso8601 unless granularity
        if granularity == :hour
          Time.new(time.year, time.month, time.day, time.hour).iso8601
        elsif granularity == :day
          Time.new(time.year, time.month, time.day).iso8601
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
      # @since 0.1.0
      def symbolize!(object)
        if object.is_a?(Array)
          object.each_with_index { |value, index| object[index] = symbolize!(value) }
        elsif object.is_a?(Hash)
          object.keys.each { |key| object[key.to_sym] = symbolize!(object.delete(key)) }
        end
        object
      end

    end

  end
end
