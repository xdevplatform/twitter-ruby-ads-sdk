# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

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
    let!(:rel_path) { "/#{TwitterAds::API_VERSION}/accounts/#{account.id}/reach_estimate" }

    before(:each) do
      stub_fixture(:get, :reach_estimate, /#{resource}\?.*/)
    end

    it 'creates proper get request with no optional parameters specified' do
      expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                   campaign_daily_budget_amount_local_micro: 30000000, bid_type: 'AUTO' }
      args = [account.client, :get, rel_path, params: expected]

      expect(Request).to receive(:new).with(*args).and_call_original
      TwitterAds::ReachEstimate.fetch(account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 30000000)
    end

    it 'creates proper get request when optional paremeters are specified' do

      expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                   campaign_daily_budget_amount_local_micro: 30000000,
                   similar_to_followers_of_user: '12', gender: '2', bid_type: 'AUTO' }
      args = [account.client, :get, rel_path, params: expected]

      expect(Request).to receive(:new).with(*args).and_call_original
      TwitterAds::ReachEstimate.fetch(
        account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 30000000,
        similar_to_followers_of_user: '12', gender: '2')

    end

    context 'without bid_type specified' do

      it 'defaults bid_type to AUTO for backward compatibility' do
        expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                     campaign_daily_budget_amount_local_micro: 30000000,
                     bid_type: 'AUTO' }
        args = [account.client, :get, rel_path, params: expected]

        expect(Request).to receive(:new).with(*args).and_call_original
        TwitterAds::ReachEstimate.fetch(account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 30000000)
      end

    end

    context 'with bid_type specified' do

      it 'does not default bid_type to AUTO' do
        expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                     bid_amount_local_micro: 3000000,
                     campaign_daily_budget_amount_local_micro: 30000000, bid_type: 'MAX' }
        args = [account.client, :get, rel_path, params: expected]

        expect(Request).to receive(:new).with(*args).and_call_original
        TwitterAds::ReachEstimate.fetch(
          account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 30000000,
          bid_amount_local_micro: 3000000, bid_type: 'MAX')
      end

    end

    context 'with bid_amount_local_micro specified' do

      it 'does not default bid_type to AUTO' do
        expected = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                     bid_amount_local_micro: 1500000,
                     campaign_daily_budget_amount_local_micro: 30000000 }
        args = [account.client, :get, rel_path, params: expected]

        expect(Request).to receive(:new).with(*args).and_call_original
        TwitterAds::ReachEstimate.fetch(
          account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 30000000, bid_amount_local_micro: 1500000)
      end

    end

  end

end
