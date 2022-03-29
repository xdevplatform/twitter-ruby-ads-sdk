# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

include TwitterAds::Enum

describe TwitterAds::Creative::Cards do

  let!(:resource) { "#{ADS_API}/accounts/2iqph/cards" }

  before(:each) do
    stub_fixture(:get, :accounts_load, "#{ADS_API}/accounts/2iqph")

    resource_collection = "#{ADS_API}/accounts/#{account.id}/cards"
    stub_fixture(:get, :cards_all, resource_collection)

    resource = "#{ADS_API}/accounts/#{account.id}/cards/1508693734346485761"
    stub_fixture(:get, :cards_load, /#{resource}\?.*/)
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

  it 'inspect Cards.load() response' do
    card = described_class.load(account, '1508693734346485761')

    expect(card).to be_instance_of(TwitterAds::Creative::Cards)
    expect(card.id).to eq '1503831318555086849'
    expect(card.card_type).to eq 'VIDEO_WEBSITE'
    expect(card.card_uri).to eq 'card://1503831318555086849'
  end

  it 'inspect Cards.all() response' do
    cards = described_class.all(account)

    expect(cards).to be_instance_of(Cursor)
    card = cards.first
    expect(card.id).to eq '1340029888649076737'
    expect(card.card_type).to eq 'VIDEO_WEBSITE'
    expect(card.card_uri).to eq 'card://1340029888649076737'
  end

end
