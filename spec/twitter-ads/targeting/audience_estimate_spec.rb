# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::AudienceEstimate do

  before(:each) do
    stub_fixture(:get, :accounts_all, "#{ADS_API}/accounts")
    stub_fixture(:get, :accounts_load, "#{ADS_API}/accounts/2iqph")
    stub_fixture(:post, :audience_estimate, "#{ADS_API}/accounts/2iqph/audience_estimate")
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
  let(:params) {
    {
      targeting_criteria: [{
        targeting_type: 'LOCATION',
        targeting_value: '96683cc9126741d1'
      }]
    }
  }

  # check model properties
  subject { described_class.fetch(account, params) }

  it 'has all the correct properties' do
    expect(subject[:audience_size][:min]).to eq(41133600)
    expect(subject[:audience_size][:max]).to eq(50274400)
  end

end
