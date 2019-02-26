# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Account do

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

  describe '#initialize' do

    let(:account) { TwitterAds::Account.new(client) }
    let(:methods) {
      %w(features promotable_users funding_instruments campaigns line_items)
    }

    it 'raises an ArgumentError error if used without initialization' do
      expect(account).to receive(:validate_loaded).and_call_original.exactly(methods.size).times
      methods.each { |meth| expect { account.send(meth) }.to raise_error(ArgumentError) }
    end

  end

  describe '#inspect' do

    it 'includes the object id value' do
      expect(account.inspect).to include(account.object_id.to_s)
    end

    it 'includes the class.name value' do
      expect(account.inspect).to include(account.class.name)
    end

    it 'includes the Account ID value' do
      expect(account.inspect).to include(account.id)
    end

  end

  describe '#features' do

    before(:each) do
      stub_fixture(:get, :accounts_features, "#{ADS_API}/accounts/#{account.id}/features")
    end

    it 'successfully returns a list of features available' do
      features = account.features
      expect(features).not_to be_nil
      expect(features).to all(be_a(String))
    end

  end

  describe '#promotable_users' do

    before(:each) do
      resource_collection = "#{ADS_API}/accounts/#{account.id}/promotable_users"
      stub_fixture(:get, :promotable_users_all, resource_collection)

      resource = "#{ADS_API}/accounts/#{account.id}/promotable_users/4k"
      stub_fixture(:get, :promotable_users_load, /#{resource}\?.*/)
    end

    context 'with an id specified' do

      it 'succesfully loads the specified promoted tweet' do
        result = account.promotable_users('4k')
        expect(result).not_to be_nil
        expect(result.class).to eq(TwitterAds::PromotableUser)
        expect(result.id).to eq('4k')
      end

    end

    context 'without an id specified' do

      it 'succesfully returns a Cursor with all promoted tweets' do
        result = account.promotable_users
        expect(result.size).to eq(5)
        expect(result.class).to eq(TwitterAds::Cursor)
        expect(result.first.class).to eq(TwitterAds::PromotableUser)
        expect(result.first.id).to eq('4k')
      end

    end

  end

  describe '#funding_instruments' do

    before(:each) do
      resource_collection = "#{ADS_API}/accounts/#{account.id}/funding_instruments"
      stub_fixture(:get, :funding_instruments_all, resource_collection)

      resource = "#{ADS_API}/accounts/#{account.id}/funding_instruments/5aa0p"
      stub_fixture(:get, :funding_instruments_load, /#{resource}\?.*/)
    end

    context 'with an id specified' do

      it 'succesfully loads the specified promoted tweet' do
        result = account.funding_instruments('5aa0p')
        expect(result).not_to be_nil
        expect(result.class).to eq(TwitterAds::FundingInstrument)
        expect(result.id).to eq('5aa0p')
      end

    end

    context 'without an id specified' do

      it 'succesfully returns a Cursor with all promoted tweets' do
        result = account.funding_instruments
        expect(result.size).to eq(3)
        expect(result.class).to eq(TwitterAds::Cursor)
        expect(result.first.class).to eq(TwitterAds::FundingInstrument)
        expect(result.first.id).to eq('5aa0p')
      end

    end

  end

  describe '#campaigns' do

    before(:each) do
      resource_collection = "#{ADS_API}/accounts/#{account.id}/campaigns"
      stub_fixture(:get, :campaigns_all, resource_collection)

      resource = "#{ADS_API}/accounts/#{account.id}/campaigns/2wap7"
      stub_fixture(:get, :campaigns_load, /#{resource}\?.*/)
    end

    context 'with an id specified' do

      it 'succesfully loads the specified promoted tweet' do
        result = account.campaigns('2wap7')
        expect(result).not_to be_nil
        expect(result.class).to eq(TwitterAds::Campaign)
        expect(result.id).to eq('2wap7')
      end

    end

    context 'without an id specified' do

      it 'succesfully returns a Cursor with all promoted tweets' do
        result = account.campaigns
        expect(result.size).to eq(10)
        expect(result.class).to eq(TwitterAds::Cursor)
        expect(result.first.class).to eq(TwitterAds::Campaign)
        expect(result.first.id).to eq('2wap7')
      end

    end

  end

  describe '#line_items' do

    before(:each) do
      resource_collection = "#{ADS_API}/accounts/#{account.id}/line_items"
      stub_fixture(:get, :line_items_all, resource_collection)

      resource = "#{ADS_API}/accounts/#{account.id}/line_items/bw2"
      stub_fixture(:get, :line_items_load, /#{resource}\?.*/)
    end

    context 'with an id specified' do

      it 'succesfully loads the specified promoted tweet' do
        result = account.line_items('bw2')
        expect(result).not_to be_nil
        expect(result.class).to eq(TwitterAds::LineItem)
        expect(result.id).to eq('bw2')
      end

    end

    context 'without an id specified' do

      it 'succesfully returns a Cursor with all promoted tweets' do
        result = account.line_items
        expect(result.size).to eq(10)
        expect(result.class).to eq(TwitterAds::Cursor)
        expect(result.first.class).to eq(TwitterAds::LineItem)
        expect(result.first.id).to eq('bw2')
      end

    end

  end

  describe '#app_lists' do

    before(:each) do
      resource_collection = "#{ADS_API}/accounts/#{account.id}/app_lists"
      stub_fixture(:get, :app_lists_all, resource_collection)

      resource = "#{ADS_API}/accounts/#{account.id}/app_lists/abc2"
      stub_fixture(:get, :app_lists_load, /#{resource}\?.*/)
    end

    context 'with an id specified' do

      it 'successfully loads the specified app list' do
        result = account.app_lists('abc2')
        expect(result).not_to be_nil
        expect(result.class).to eq(TwitterAds::AppList)
        expect(result.id).to eq('abc2')
      end

    end

    context 'without an id specified' do

      it 'succesfully returns a cursor with all app lists' do
        result = account.app_lists
        expect(result.to_a.size).to eq(3)
        expect(result.class).to eq(TwitterAds::Cursor)
        expect(result.first.class).to eq(TwitterAds::AppList)
        expect(result.first.id).to eq('abc2')
      end

    end

  end

  describe '#tailored_audiences' do

    before(:each) do
      resource_collection = "#{ADS_API}/accounts/#{account.id}/tailored_audiences"
      stub_fixture(:get, :tailored_audiences_all, resource_collection)

      resource = "#{ADS_API}/accounts/#{account.id}/tailored_audiences/abc2"
      stub_fixture(:get, :tailored_audiences_load, /#{resource}\?.*/)
    end

    context 'with an id specified' do

      it 'successfully loads the specified tailored audience' do
        result = account.tailored_audiences('abc2')
        expect(result).not_to be_nil
        expect(result.class).to eq(TwitterAds::TailoredAudience)
        expect(result.id).to eq('abc2')
      end

    end

    context 'without an id specified' do

      it 'succesfully returns a cursor with all tailored audiences' do
        result = account.tailored_audiences
        expect(result.to_a.size).to eq(3)
        expect(result.class).to eq(TwitterAds::Cursor)
        expect(result.first.class).to eq(TwitterAds::TailoredAudience)
        expect(result.first.id).to eq('abc2')
      end

    end

  end

end
