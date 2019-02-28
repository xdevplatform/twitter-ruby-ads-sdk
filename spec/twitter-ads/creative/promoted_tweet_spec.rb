# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::Creative::PromotedTweet do

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
  read  = %w(id approval_status created_at updated_at deleted entity_status)
  write = %w(line_item_id tweet_id)
  include_examples 'object property check', read, write

  describe '#save' do

    it 'raises a client error when missing tweet_id' do
      expect(subject).to receive(:validate).and_call_original
      subject.line_item_id = '12345'
      expect { subject.save }.to raise_error(TwitterAds::ClientError)
    end

    it 'raises a client error when missing line_item_id' do
      expect(subject).to receive(:validate).and_call_original
      subject.tweet_id = 99999999999999999999
      expect { subject.save }.to raise_error(TwitterAds::ClientError)
    end

  end

end
