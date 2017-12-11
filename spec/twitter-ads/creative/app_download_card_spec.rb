# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Creative::AppDownloadCard do

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
  read  = %w(card_type card_uri created_at deleted updated_at)

  write = %w(
    name
    app_country_code
    iphone_app_id
    iphone_deep_link
    ipad_app_id
    ipad_deep_link
    googleplay_app_id
    googleplay_deep_link
    app_cta
    custom_icon_media_id
    custom_app_description
  )

  include_examples 'object property check', read, write

end
