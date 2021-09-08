# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

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
    android_app_store_identifier
    audience_expansion
    categories
    pay_by
    objective
    entity_status
    primary_web_event_tag
    product_type
    placements
    bid_strategy
    bid_amount_local_micro
    total_budget_amount_local_micro
    goal
    ios_app_store_identifier
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

end
