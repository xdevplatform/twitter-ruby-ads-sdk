# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Client do

  let!(:consumer_key) { Faker::Lorem.characters(15) }
  let!(:consumer_secret) { Faker::Lorem.characters(40) }
  let!(:access_token) { "123456-#{Faker::Lorem.characters(40)}" }
  let!(:access_token_secret) { Faker::Lorem.characters(40) }

  let(:client) do
    Client.new(
      consumer_key,
      consumer_secret,
      access_token,
      access_token_secret
    )
  end

  describe '#initialize' do

    it 'requires a valid consumer_key' do
      expect(client.consumer_key).not_to be_nil
      expect(client.consumer_key).to eq(consumer_key)
      expect {
        Client.new(nil, consumer_secret, access_token, access_token_secret)
      }.to raise_error(ArgumentError)
    end

    it 'requires a valid consumer_secret' do
      expect(client.consumer_secret).not_to be_nil
      expect(client.consumer_secret).to eq(consumer_secret)
      expect {
        Client.new(consumer_key, nil, access_token, access_token_secret)
      }.to raise_error(ArgumentError)
    end

    it 'requires a valid access_token' do
      expect(client.access_token).not_to be_nil
      expect(client.access_token).to eq(access_token)
      expect {
        Client.new(consumer_key, consumer_secret, nil, access_token_secret)
      }.to raise_error(ArgumentError)
    end

    it 'requires a valid access_token_secret' do
      expect(client.access_token_secret).not_to be_nil
      expect(client.access_token_secret).to eq(access_token_secret)
      expect {
        Client.new(consumer_key, consumer_secret, access_token, nil)
      }.to raise_error(ArgumentError)
    end

    it 'allows additional options' do
      expect {
        Client.new(consumer_key, consumer_secret, access_token, access_token_secret, options: {})
      }.not_to raise_error
    end

    it 'test client options' do
      client = Client.new(
        consumer_key,
        consumer_secret,
        access_token,
        access_token_secret,
        options: {
          handle_rate_limit: true,
          retry_max: 1,
          retry_delay: 3000,
          retry_on_status: [404, 500, 503]
        }
      )
      expect(client.options.length).to eq 4
    end

  end

  describe '#inspect' do

    it 'includes the object id value' do
      expect(client.inspect).to include(client.object_id.to_s)
    end

    it 'includes the consumer_key value' do
      expect(client.inspect).to include(client.consumer_key)
    end

    it 'includes the class.name value' do
      expect(client.inspect).to include(client.class.name)
    end

  end

  describe '#accounts' do

    context 'when called with no arguments' do

      before(:all) do
        stub_fixture(:get, :accounts_all, "#{ADS_API}/accounts")
      end

      it 'returns a Cursor object' do
        cursor = client.accounts
        expect(cursor.class.name).to eq('TwitterAds::Cursor')
        expect(cursor.size).to eq(5)
        expect(cursor.first.class.name).to eq('TwitterAds::Account')
      end

    end

    context 'when called with an account id' do

      let!(:account_id) { '2iqph' }

      before(:all) do
        stub_fixture(:get, :accounts_load,
                     /(.*\/#{TwitterAds::API_VERSION}\/accounts\/)([a-zA-Z0-9]*)\z/)
      end

      it 'returns a specific Account object' do
        cursor = client.accounts(account_id)
        expect(cursor.class.name).to eq('TwitterAds::Account')
        expect(cursor.id).to eq(account_id)
      end

    end

  end

end
