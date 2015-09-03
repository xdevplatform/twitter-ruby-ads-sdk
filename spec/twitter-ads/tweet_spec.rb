# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Tweet do

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

  describe '#tweet_preview' do

    let!(:resource_collection) { "#{ADS_API}/accounts/#{account.id}/tweet/preview" }

    before(:each) do
      stub_fixture(:get, :tweet_preview, /#{resource_collection}.*/)
    end

    context 'with an id specified' do

      it 'loads preview of the specified tweet' do

        id = 123_456

        params = { id: id }
        result = subject.preview(account, params)
        expect(result.size).not_to be_nil
        expect(result).to all(include(:platform, :preview))
      end

    end

    context 'when previewing a new tweet' do

      it 'returns preview' do

        status = 'Hello World!'
        card_id = 'pfs'

        params = { status: status, card_id: card_id }

        result = subject.preview(account, params)
        expect(result.size).not_to be_nil
        expect(result).to all(include(:platform, :preview))
      end

    end

  end

end
