# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

include TwitterAds::Enum

describe TwitterAds::LineItem do

  let(:client) do
    Client.new(
      Faker::Lorem.characters(15),
      Faker::Lorem.characters(40),
      "123456-#{Faker::Lorem.characters(40)}",
      Faker::Lorem.characters(40)
    )
  end

  describe '#placements' do

    before(:each) do
      url = Addressable::Template.new "#{ADS_API}/line_items/placements{?product_type}"
      stub_fixture(:get, :placements, url)
    end

    let(:product_type) { Product::PROMOTED_TWEETS }

    it 'successfully fetches valid placement / product type combinations' do
      expect(TwitterAds::Utils).not_to receive(:deprecated)
      result = silence { described_class.placements(client, product_type) }
      expect(result.size).not_to be_nil
      expect(result).to all(be_a(Array))
    end

    it 'allows product_type to be an optional method argument' do
      expect(TwitterAds::Utils).not_to receive(:deprecated)
      result = silence { described_class.placements(client) }
      expect(result.size).not_to be_nil
      expect(result).to all(be_a(Array))
    end

  end

end
