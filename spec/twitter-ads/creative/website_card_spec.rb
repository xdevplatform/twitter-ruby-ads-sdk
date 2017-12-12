# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Creative::WebsiteCard do

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
  read = %w(
    card_type
    card_uri
    created_at
    deleted
    id
    image
    image_display_height
    image_display_width
    preview_url
    website_dest_url
    website_display_url
    updated_at
  )
  write = %w(image_media_id name website_title website_url)
  include_examples 'object property check', read, write

end
