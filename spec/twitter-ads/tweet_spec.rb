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

    context 'with an existing tweet id' do

      it 'successfully returns a preview of the specified tweet' do
        params = { id: 634798319504617472 }
        result = subject.preview(account, params)
        expect(result.size).not_to be_nil
        expect(result).to all(include(:platform, :preview))
      end

    end

    context 'when previewing a new tweet' do

      it 'url encodes the status content' do
        params = { status: 'Hello World!', card_id: '19v69' }
        expect(URI).to receive(:escape).at_least(:once).and_call_original
        result = subject.preview(account, params)
        expect(result.size).not_to be_nil
        expect(result).to all(include(:platform, :preview))
      end

      it 'allows a single value for the media_ids param' do
        resource = "/0/accounts/#{account.id}/tweet/preview"
        expected = { status: 'Hello%20World!', media_ids: 634458428836962304 }

        expect(TwitterAds::Request).to receive(:new).with(
          account.client, :get, resource, params: expected).and_call_original

        params = { status: 'Hello World!', media_ids: 634458428836962304 }
        result = subject.preview(account, params)
        expect(result.size).not_to be_nil
        expect(result).to all(include(:platform, :preview))
      end

      it 'allows an array of vaues for the media_ids param' do
        resource = "/0/accounts/#{account.id}/tweet/preview"
        expected = { status: 'Hello%20World!', media_ids: '634458428836962304,634458428836962305' }

        expect(TwitterAds::Request).to receive(:new).with(
          account.client, :get, resource, params: expected).and_call_original

        params = { status: 'Hello World!', media_ids: [634458428836962304, 634458428836962305] }
        result = subject.preview(account, params)
        expect(result.size).not_to be_nil
        expect(result).to all(include(:platform, :preview))
      end

    end

  end

end
