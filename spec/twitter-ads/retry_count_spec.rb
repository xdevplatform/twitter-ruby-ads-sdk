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
      Faker::Lorem.characters(40),
      options: {
        retry_max: 1,
        retry_delay: 3000,
        retry_on_status: [404, 500, 503]
      }
    )
  end
  let(:account) { client.accounts('2iqph') }

  it 'test retry count - success' do
    stub = stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 404
      },
      {
        body: fixture(:campaigns_all),
        status: 200
      }
    )
    cusor = described_class.all(account)
    expect(cusor).to be_instance_of(Cursor)
    expect(stub).to have_been_requested.times(2)
  end

  it 'test retry count - fail' do
    stub = stub_request(:get, "#{ADS_API}/accounts/2iqph/campaigns").to_return(
      {
        body: fixture(:campaigns_all),
        status: 404
      }
    ).times(2)

    begin
      cusor = described_class.all(account)
    rescue NotFound => e
      cusor = e
    end
    expect(cusor).to be_instance_of(NotFound)
    expect(stub).to have_been_requested.times(2)
  end

end
