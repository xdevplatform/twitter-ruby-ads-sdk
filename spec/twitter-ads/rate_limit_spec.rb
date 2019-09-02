# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Campaign do

  before(:each) do
    allow_any_instance_of(Object).to receive(:sleep)
    stub_fixture(:get, :accounts_load, "#{ADS_API}/accounts/2iqph")
  end

  let(:client) do
    Client.new(
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40)
    )
  end
  let(:account) { client_simple.accounts('2iqph') }

  let(:client_simple) do
    Client.new(
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      options: {
        handle_rate_limit: true
      }
    )
  end
  let(:account1) { client_simple.accounts('2iqph') }

  let(:client_combine) do
    Client.new(
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      options: {
        handle_rate_limit: true,
        retry_max: 1,
        retry_delay: 3000,
        retry_on_status: [500]
      }
    )
  end
  let(:account2) { client_combine.accounts('2iqph') }

  it 'test rate-limit handle - success' do
    stub = stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 429,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': Time.now.to_i + 5
        }
      },
      {
        body: fixture(:campaigns_all),
        status: 200
      }
    )
    cusor = described_class.all(account1)
    expect(cusor).to be_instance_of(Cursor)
    expect(stub).to have_been_requested.times(2)
  end

  it 'test rate-limit handle - fail' do
    stub = stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 429,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': Time.now.to_i + 5
        }
      },
      {
        body: fixture(:campaigns_all),
        status: 429,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': 4102444800
        }
      }
    )
    begin
      cusor = described_class.all(account1)
    rescue RateLimit => e
      cusor = e
    end
    expect(cusor).to be_instance_of(RateLimit)
    expect(stub).to have_been_requested.times(2)
    expect(cusor.reset_at).to eq 4102444800
  end

  it 'test rate-limit handle with retry - case 1' do
    # scenario:
    #  - 500 (retry) -> 429 (handle rate limit) -> 200 (end)
    stub = stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 500,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': 4102444800
        }
      },
      {
        body: fixture(:campaigns_all),
        status: 429,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': Time.now.to_i + 5
        }
      },
      {
        body: fixture(:campaigns_all),
        status: 200
      }
    )
    cusor = described_class.all(account2)
    expect(cusor).to be_instance_of(Cursor)
    expect(stub).to have_been_requested.times(3)
  end

  it 'test rate-limit handle with retry - case 2' do
    # scenario:
    #  - 429 (handle rate limit) -> 500 (retry) -> 200 (end)
    stub = stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 429,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': Time.now.to_i + 5
        }
      },
      {
        body: fixture(:campaigns_all),
        status: 500,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': 4102444800
        }
      },
      {
        body: fixture(:campaigns_all),
        status: 200
      }
    )
    cusor = described_class.all(account2)
    expect(cusor).to be_instance_of(Cursor)
    expect(stub).to have_been_requested.times(3)
  end

  it 'test rate-limit header access from cusor class' do
    stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 200,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': 4102444800
        }
      }
    )
    cusor = described_class.all(account)
    expect(cusor).to be_instance_of(Cursor)
    expect(cusor.account_rate_limit_limit).to eq 10000
    expect(cusor.account_rate_limit_remaining).to eq 9999
    expect(cusor.account_rate_limit_reset).to eq 4102444800
  end

  it 'test rate-limit header access from resource class' do
    stub_request(:any, /accounts\/2iqph\/campaigns\/2wap7/).to_return(
      {
        body: fixture(:campaigns_load),
        status: 200,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': 4102444800
        }
      }
    )

    campaign = described_class.load(account, '2wap7')
    resource = "/#{TwitterAds::API_VERSION}/accounts/2iqph/campaigns/2wap7"
    params   = {}
    response = TwitterAds::Request.new(client, :get, resource, params: params).perform
    data     = campaign.from_response(response.body[:data], response.headers)
    expect(data).to be_instance_of(Campaign)
    expect(data.account_rate_limit_limit).to eq 10000
    expect(data.account_rate_limit_remaining).to eq 9999
    expect(data.account_rate_limit_reset).to eq 4102444800
  end

  it 'test rate-limit header access check instance variables not conflicting' do
    stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 200,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9999,
          'x-account-rate-limit-reset': 4102444800
        }
      },
      {
        body: fixture(:campaigns_all),
        status: 200,
        headers: {
          'x-account-rate-limit-limit': 10000,
          'x-account-rate-limit-remaining': 9998,
          'x-account-rate-limit-reset': 4102444800
        }
      }
    )

    campaign_first = described_class.all(account)
    campaign_second = described_class.all(account)

    expect(campaign_first).to be_instance_of(Cursor)
    expect(campaign_first.account_rate_limit_limit).to eq 10000
    expect(campaign_first.account_rate_limit_remaining).to eq 9999
    expect(campaign_first.account_rate_limit_reset).to eq 4102444800

    expect(campaign_second).to be_instance_of(Cursor)
    expect(campaign_second.account_rate_limit_limit).to eq 10000
    expect(campaign_second.account_rate_limit_remaining).to eq 9998
    expect(campaign_second.account_rate_limit_reset).to eq 4102444800
  end

end
