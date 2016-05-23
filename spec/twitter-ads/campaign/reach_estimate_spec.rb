# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::ReachEstimate do

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

  describe '#fetch' do

    let!(:resource) { "#{ADS_API}/accounts/#{account.id}/reach_estimate" }
    let!(:rel_path) { "/1/accounts/#{account.id}/reach_estimate" }

    before(:each) do
      stub_fixture(:get, :reach_estimate, /#{resource}\?.*/)
    end

    it 'creates proper get request with no optional parameters specified' do
      expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                   user_id: 12, bid_type: 'AUTO' }
      args = [account.client, :get, rel_path, params: expected]

      expect(Request).to receive(:new).with(*args).and_call_original
      TwitterAds::ReachEstimate.fetch(account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 12)
    end

    it 'creates proper get request when optional paremeters are specified' do

      expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                   user_id: 12, similar_to_followers_of_user: '12', gender: '2', bid_type: 'AUTO' }
      args = [account.client, :get, rel_path, params: expected]

      expect(Request).to receive(:new).with(*args).and_call_original
      TwitterAds::ReachEstimate.fetch(
        account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 12,
        similar_to_followers_of_user: '12', gender: '2')

    end

    context 'without bid_type specified' do

      it 'defaults bid_type to AUTO for backward compatibility' do
        expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                     user_id: 12, bid_type: 'AUTO' }
        args = [account.client, :get, rel_path, params: expected]

        expect(Request).to receive(:new).with(*args).and_call_original
        TwitterAds::ReachEstimate.fetch(account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 12)
      end

    end

    context 'with bid_type specified' do

      it 'does not default bid_type to AUTO' do
        expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                     user_id: 12, bid_type: 'MAX' }
        args = [account.client, :get, rel_path, params: expected]

        expect(Request).to receive(:new).with(*args).and_call_original
        TwitterAds::ReachEstimate.fetch(
          account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 12, bid_type: 'MAX')
      end

    end

    context 'with bid_amount_local_micro specified' do

      it 'does not default bid_type to AUTO' do
        expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                     user_id: 12, bid_amount_local_micro: 1500000 }
        args = [account.client, :get, rel_path, params: expected]

        expect(Request).to receive(:new).with(*args).and_call_original
        TwitterAds::ReachEstimate.fetch(
          account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 12, bid_amount_local_micro: 1500000)
      end

    end

  end

end
