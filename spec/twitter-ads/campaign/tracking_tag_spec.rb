# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::TrackingTag do

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
  read  = %w(id)
  write = %w(line_item_id tracking_tag_type tracking_tag_url)
  include_examples 'object property check', read, write

  describe '#create' do

    let(:tracking_tag) { TwitterAds::TrackingTag.new(account) }
    let!(:resource) { "#{ADS_API}/accounts/#{account.id}/tracking_tags" }
    let!(:rel_path) { "/#{TwitterAds::API_VERSION}/accounts/#{account.id}/tracking_tags" }

    before(:each) do
      stub_fixture(:post, :tracking_tags_load, /#{resource}\?.*/)
    end

    it 'creates post request with line item ID and url' do
      line_item_id = 'axe123'
      tracking_tag_url = 'https://ad.doubleclick.net/ddm/trackimp/N1234.2061500TWITTER-OFFICIAL/B9156151.125630439;dc_trk_aid=1355;dc_trk_cid=8675309'
      tracking_tag_type = 'IMPRESSION_TAG'

      params = {
        line_item_id: line_item_id,
        tracking_tag_url: tracking_tag_url,
        tracking_tag_type: tracking_tag_type
      }
      args = [account.client, :post, rel_path, params: params]

      expect(Request).to receive(:new).with(*args).and_call_original
      tracking_tag.create(line_item_id, tracking_tag_url)
    end

  end

end
