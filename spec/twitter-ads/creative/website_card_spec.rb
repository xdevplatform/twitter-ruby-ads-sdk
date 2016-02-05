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
  read  = %w(id preview_url created_at updated_at deleted)
  write = %w(name website_title website_url website_cta image_media_id)
  include_examples 'object property check', read, write

  it 'raises a warning message each time website_cta is set' do
    expect(subject).to receive(:warn).with(
      "[DEPRECATED] The 'website_cta' property has been deprecated from #{subject.class}. " \
      'Please see https://t.co/deprecated-website-card-cta for more info.')
    subject.website_cta = 'anyvalue'
  end

end
