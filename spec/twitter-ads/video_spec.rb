# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Video do

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

  read  = %w(
    id
    tweeted
    ready_to_tweet
    duration
    reasons_not_servable
    preview_url
    created_at
    updated_at
    deleted
  )

  write = %w(title description video_media_id)

  include_examples 'object property check', read, write

end
