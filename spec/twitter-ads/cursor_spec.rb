# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Cursor do

  before(:each) do
    stub_fixture(:get, :accounts_all, "#{ADS_API}/accounts")
    stub_fixture(:get, :accounts_load, "#{ADS_API}/accounts/2iqph")
    stub_fixture(:get, :campaigns_all, "#{ADS_API}/accounts/2iqph/campaigns")
    stub_fixture(:get, :app_lists_all, "#{ADS_API}/accounts/2iqph/app_lists")
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

  describe '#last' do

    let(:cursor) { account.campaigns }

    it 'exhausts the Cursor and returns the last object' do
      expect(cursor).to receive(:each).and_call_original
      result = cursor.last
      expect(result).not_to be_nil
      expect(result).to eq(cursor.instance_variable_get('@collection').last)
      expect(cursor.exhausted?).to be true
    end

  end

  describe '#count' do

    context 'for non-standard responses' do

      let(:cursor) { account.app_lists }

      it 'returns the correct count for non-standard responses' do
        expect(cursor.count).to eq(3)
        expect(cursor.instance_variable_get('@total_count')).to be_nil
        expect(cursor.exhausted?).to be true
      end

    end

    context 'for standard responses' do

      let(:cursor) { account.campaigns }

      it 'returns the correct count for non-standard responses' do
        expect(cursor.instance_variable_get('@total_count')).not_to be_nil
        expect(cursor.count).to eq(cursor.instance_variable_get('@total_count'))
      end

    end

  end

end
