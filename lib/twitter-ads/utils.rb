# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Utils

    class << self

      def to_bool(object)
        (object.to_s.downcase == 'false') ? false : !!object
      end

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
