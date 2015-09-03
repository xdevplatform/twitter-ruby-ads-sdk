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

  describe '#get_reach_estimate' do

    let!(:resource) { "#{ADS_API}/accounts/#{account.id}/reach_estimate" }
    let!(:rel_path) { "/0/accounts/#{account.id}/reach_estimate" }

    before(:each) do
      stub_fixture(:get, :reach_estimate, /#{resource}\?.*/)
    end

    it 'creates proper get request with no optional parameters specified' do

      params = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                 user_id: 12 }
      args = [account.client, :get, rel_path, params: params]
      expect(Request).to receive(:new).with(*args).and_call_original
      TwitterAds::ReachEstimate.fetch(
        account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 12)

    end

    it 'creates proper get request when optional paremeters are specified' do

      params = { product_type: 'PROMOTED_TWEETS', objective: 'WEBSITE_CLICKS',
                 user_id: 12, similar_to_followers_of_user: '12', gender: '2' }
      args = [account.client, :get, rel_path, params: params]
      expect(Request).to receive(:new).with(*args).and_call_original
      TwitterAds::ReachEstimate.fetch(
        account, 'PROMOTED_TWEETS', 'WEBSITE_CLICKS', 12,
        similar_to_followers_of_user: '12', gender: '2')

    end

  end

end
