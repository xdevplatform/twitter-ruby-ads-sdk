# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Campaign do

  before(:each) do
    allow_any_instance_of(Object).to receive(:sleep)
    stub_fixture(:get, :accounts_load, "#{ADS_API}/accounts/2iqph")
  end

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
    expect(cusor.instance_of?(Cursor))
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
    expect(cusor.instance_of?(RateLimit))
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
    expect(cusor.instance_of?(Cursor))
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
    expect(cusor.instance_of?(Cursor))
    expect(stub).to have_been_requested.times(3)
  end

end
