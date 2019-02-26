# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Creative::ImageAppDownloadCard do

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
  read  = %w(id preview_url created_at updated_at deleted)

  write = %w(
    name
    country_code
    iphone_app_id
    iphone_deep_link
    ipad_app_id
    ipad_deep_link
    googleplay_app_id
    googleplay_deep_link
    app_cta
    wide_app_image_media_id
  )

  include_examples 'object property check', read, write

end
