# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::AppList do

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

  # check model properties
  subject { described_class.new(account) }
  read  = %w(id apps name)
  write = []
  include_examples 'object property check', read, write

  describe '#create' do

    let(:app_list) { TwitterAds::AppList.new(account) }
    let!(:resource) { "#{ADS_API}/accounts/#{account.id}/app_lists" }
    let!(:rel_path) { "/#{TwitterAds::API_VERSION}/accounts/#{account.id}/app_lists" }

    before(:each) do
      stub_fixture(:post, :app_lists_load, /#{resource}\?.*/)
    end

    it 'creates post request with single app ID and name' do
      name = 'Some test app list'
      app = 'io.fabric.samples.cannonball'

      params = { app_store_identifiers: app, name: name }
      args = [account.client, :post, rel_path, params: params]

      expect(Request).to receive(:new).with(*args).and_call_original
      app_list.create(name, app)
    end

    it 'creates post request with multiple app IDs and name' do
      name = 'Some test app list'
      apps = ['com.supercell.clashofclans', 'com.functionx.viggle',
              'io.fabric.samples.cannonball', 'com.hoteltonight.android.prod']

      params = { app_store_identifiers: apps.join(','), name: name }
      args = [account.client, :post, rel_path, params: params]

      expect(Request).to receive(:new).with(*args).and_call_original
      app_list.create(name, apps)
    end

  end

  describe '#apps' do

    let(:app_list) { TwitterAds::AppList.new(account) }
    let!(:resource) { "#{ADS_API}/accounts/#{account.id}/app_lists/abc2" }

    context 'when @apps is nil' do

      before(:each) do
        app_list.instance_variable_set('@apps', nil)
        app_list.instance_variable_set('@id', 'abc2')
        stub_fixture(:get, :app_lists_load, /#{resource}/)
      end

      it 'reloads the object from the server' do
        expect(app_list).to receive(:reload!).and_call_original
        app_list.apps
        expect(app_list.instance_variable_get('@apps')).not_to be_nil
      end
    end

    context 'when @apps is not nil' do

      let(:apps) {
        [
          {
            'app_store_identifier' => 'io.fabric.samples.cannonball',
            'os_type' => 'Android'
          }
        ]
      }

      before(:each) do
        app_list.instance_variable_set('@apps', apps)
        app_list.instance_variable_set('@id', 'abc2')
      end

      it 'does not reload the object from the server' do
        expect(app_list).not_to receive(:reload!)
        app_list.apps
        expect(app_list.apps).to eq(apps)
      end
    end
  end
end
