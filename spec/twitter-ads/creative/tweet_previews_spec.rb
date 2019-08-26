# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

include TwitterAds::Enum

describe TwitterAds::Creative::TweetPreview do

  let!(:resource) { "#{ADS_API}/accounts/2iqph/tweet_previews" }

  before(:each) do
    stub_fixture(:get, :accounts_load, "#{ADS_API}/accounts/2iqph")
    stub_fixture(:get, :tweet_previews, /#{resource}\?.*/)
  end

  let(:client) do
    Client.new(
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40),
      Faker::Lorem.characters(40)
    )
  end

  let(:account) { client.accounts('2iqph') }
  let(:instance) { described_class.new(account) }

  it 'inspect TweetPreview.load() response' do
    preview = instance.load(
      account,
      tweet_ids: %w(1130942781109596160 1101254234031370240),
      tweet_type: TweetType::PUBLISHED)

    expect(preview).to be_instance_of(Cursor)
    expect(preview.count).to eq 2
    tweet = preview.first
    expect(tweet.tweet_id).to eq '1130942781109596160'
  end

end
