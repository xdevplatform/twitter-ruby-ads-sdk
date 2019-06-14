# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Utils do

  describe '#to_bool' do

    it 'successfully coerces "nil" to its correct boolean value' do
      expect(subject.to_bool(nil)).to be false
    end

    it 'successfully coerces "true" to its correct boolean value' do
      expect(subject.to_bool(true)).to be true
    end

    it 'successfully coerces "false" to its correct boolean value' do
      expect(subject.to_bool(false)).to be false
    end

    it 'does not coerces numerical values' do
      expect(subject.to_bool(0)).to be true
      expect(subject.to_bool(1)).to be true
      expect(subject.to_bool(999)).to be true
    end

  end

  describe '#to_time' do

    let(:time) { Time.now }

    context 'when a granularity is not specified' do

      it 'returns the ISO 8601 formatted string' do
        expect(subject.to_time(time)).to eq(time.iso8601)
      end

    end

    context 'when a granularity is specified' do

      it 'returns the ISO 8601 formatted string for :hour rounded to the hour' do
        expected_result = Time.new(time.year, time.month, time.day, time.hour).iso8601
        expect(subject.to_time(time, :hour)).to eq(expected_result)
      end

      it 'returns the ISO 8601 formatted string for :day rounded to the day' do
        expected_result = Time.new(time.year, time.month, time.day).iso8601
        expect(subject.to_time(time, :day)).to eq(expected_result)
      end

      it 'returns the ISO 8601 formatted string for all other granularities' do
        expect(subject.to_time(time, :total)).to eq(time.iso8601)
      end

    end

  end

  describe '#symbolize!' do

    context 'with a simple object' do

      let(:simple) { { 'key1' => 'foo', 'key2' => 'bar', 'key3' => 1234 } }

      it 'successfully converts all keys to symbols' do
        result = subject.symbolize!(simple)
        expect(result.keys).to all(be_a(Symbol))
      end

    end

    context 'with a nested object' do

      let(:nested) { { 'key1' => 'foo', 'key2' => { 'key3' => 1 } } }

      it 'successfully converts the nested object keys to symbols' do
        result = subject.symbolize!(nested)
        expect(result.keys).to all(be_a(Symbol))
        expect(result[:key2].keys).to all(be_a(Symbol))
      end

    end

    context 'with a nested collection of objects' do

      let(:nested) { { 'key1' => 'foo', 'key2' => [{ 'key3' => 1 }] } }

      it 'successfully converts the collection of objects keys to symbols' do
        result = subject.symbolize!(nested)
        expect(result.keys).to all(be_a(Symbol))
        expect(result[:key2][0].keys).to all(be_a(Symbol))
      end

    end

  end

end
