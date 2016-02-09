# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

include TwitterAds::Enum

describe TwitterAds::LineItem do

  before(:each) do
    stub_fixture(:get, :accounts_all, "#{ADS_API}/accounts")
    stub_fixture(:get, :accounts_load, "#{ADS_API}/accounts/2iqph")
  end

  let(:client) do
    Client.new(
      Faker::Lorem.characters(15),
      Faker::Lorem.characters(40),
      "123456-#{Faker::Lorem.characters(40)}",
      Faker::Lorem.characters(40)
    )
  end

  let(:account) { client.accounts.first }

  # check model properties
  subject { described_class.new(account) }
  read  = %w(id created_at updated_at deleted)
  write = %w(
    name
    campaign_id
    advertiser_domain
    categories
    charge_by
    include_sentiment
    objective
    paused
    primary_web_event_tag
    product_type
    placements
    bid_unit
    automatically_select_bid
    bid_amount_local_micro
    total_budget_amount_local_micro
  )
  include_examples 'object property check', read, write

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

  describe '#objective=' do

    context 'when using TwitterAds::Objective::CUSTOM' do

      it 'raises a warning message' do
        expect(TwitterAds::Utils).to receive(:deprecated).with('TwitterAds::Objective::CUSTOM')
        subject.objective = TwitterAds::Objective::CUSTOM
      end

    end

    context 'when using any object other than TwitterAds::Objective::CUSTOM' do

      it 'does not raise a warning message' do
        expect(TwitterAds::Utils).not_to receive(:deprecated).with(any_args)
        subject.objective = TwitterAds::Objective::VIDEO_VIEWS
      end

    end

  end

end
