# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Creative::LeadGenCard do

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
    image_media_id
    cta
    fallback_url
    privacy_policy_url
    title
    submit_url
    submit_method
    custom_destination_url
    custom_destination_text
    custom_key_screen_name
    custom_key_name
    custom_key_email
  )

  include_examples 'object property check', read, write

end
