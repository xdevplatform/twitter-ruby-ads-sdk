# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::TailoredAudience do

  before(:each) do
    stub_fixture(:get, :accounts_all, "#{ADS_API}/accounts")
    stub_fixture(:get,
                 :tailored_audiences_load,
                 "#{ADS_API}/accounts/2iqph/tailored_audiences/abc2?with_deleted=true")
    stub_fixture(:get,
                 :targeted_audiences,
                 "#{ADS_API}/accounts/2iqph/tailored_audiences/abc2/targeted")
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
  let(:tailored_audience) { described_class.load(account, 'abc2') }
  # check model properties
  subject { described_class.new(account) }

  read = %w(
    id
    created_at
    updated_at
    deleted
    owner_account_id
    audience_size
    audience_type
    metadata
    partner_source
    reasons_not_targetable
    targetable
    targetable_types
  )

  write = %w(name list_type)

  include_examples 'object property check', read, write

  describe '#targeted' do

    let(:cursor) { tailored_audience.targeted }

    it 'has all the correct properties' do
      result = cursor.first
      expect(result).to eq(cursor.instance_variable_get('@collection').first)
      expect(result).to be_instance_of(TwitterAds::TargetedTailoredAudience)
      expect(cursor).to be_instance_of(Cursor)
    end

    it 'raises error when TailoredAudience is not loaded' do
      result = TwitterAds::TailoredAudience.new(account)
      expect(result).to receive(:validate_loaded).and_call_original
      expect { result.targeted }.to raise_error(ArgumentError)
    end
  end
end
