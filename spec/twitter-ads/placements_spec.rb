# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Placement do

  let(:client) do
    Client.new(
      Faker::Lorem.characters(15),
      Faker::Lorem.characters(40),
      "123456-#{Faker::Lorem.characters(40)}",
      Faker::Lorem.characters(40)
    )
  end

  describe '#valid_combinations' do

    before(:each) do
      url = Addressable::Template.new "#{ADS_API}/line_items/placements{?product_type}"
      stub_fixture(:get, :placements, url)
    end

    let(:product_type) { TwitterAds::Product::PROMOTED_TWEETS }

    it 'successfully fetches valid placement / product type combinations' do
      expect(TwitterAds::Utils).to receive(:deprecated).and_call_original
      expect(TwitterAds::LineItem).to receive(:placements).and_call_original
      result = silence { subject.valid_combinations(client, product_type) }
      expect(result.size).not_to be_nil
      expect(result).to all(be_a(Array))
    end

  end

end
