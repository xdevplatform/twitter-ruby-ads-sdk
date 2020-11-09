# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe TwitterAds::TargetingCriteria do

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

  read = %w(id name localized_name created_at updated_at deleted)

  write = %w(
    line_item_id
    targeting_type
    targeting_value
    operator_type
    tailored_audience_expansion
  )

  include_examples 'object property check', read, write

end
