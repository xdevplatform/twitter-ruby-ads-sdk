# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

require 'spec_helper'
require 'tempfile'

describe TwitterAds::TONUpload do
  before(:each) do
    stub_fixture(
      :post, :no_content, "#{TON_API}/1.1/ton/bucket/#{bucket_name}",
      headers: {
        'location' => location_path
      }
    )
    stub_fixture(
      :post, :no_content, "#{TON_API}/1.1/ton/bucket/#{bucket_name}?resumable=true",
      headers: {
        'location' => "#{location_path}?resumable=true&resumeId=1234567",
        'x-ton-min-chunk-size' => '1048576'
      }
    )
  end
  let(:bucket_name) { 'ta_partner' }
  let(:location_path) { '/1.1/ton/data/ta_partner/123456789/tYfALUIK-F3ZMxj.txt' }

  around(:each) do |example|
    example.run
    file.unlink
  end
  let!(:file) do
    Tempfile.open(['', '.dat'], File.expand_path('../../../tmp/', __FILE__)) do |fp|
      fp.tap { |f| f.write(SecureRandom.random_bytes(file_size)) }
    end
  end
  let(:file_size) { 100 }

  let(:ton_upload) { described_class.new(client, file_path) }
  let(:client) do
    Client.new(
      Faker::Lorem.characters(15),
      Faker::Lorem.characters(40),
      "123456-#{Faker::Lorem.characters(40)}",
      Faker::Lorem.characters(40)
    )
  end
  let(:file_path) { file.path }

  describe '#initialize' do

    subject { ton_upload }
    it { is_expected.to be_an_instance_of described_class }

    context 'when the file path is invalid' do
      let(:file_path) { '/invalid/file/path' }

      it do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe '#perform' do
    subject { ton_upload.perform }

    it 'should call TwitterAds::Request#perform exactly once' do
      expect_any_instance_of(TwitterAds::Request).to receive(:perform).once.and_call_original
      subject
    end

    it { is_expected.to eq '/1.1/ton/data/ta_partner/123456789/tYfALUIK-F3ZMxj.txt' }

    context 'when the file size is larger than 64MB' do
      before(:each) do
        allow(ton_upload).to receive(:upload_chunk)
      end
      let(:file_size) { 65 * 1024 * 1024 }

      it { is_expected.to eq '/1.1/ton/data/ta_partner/123456789/tYfALUIK-F3ZMxj.txt' }
      it 'should call TwitterAds::Request#perform exactly once' do
        expect(ton_upload).to receive(:upload_chunk).at_least(:twice)
        subject
      end
    end
  end

  describe '#inspect' do
    subject { ton_upload.inspect }

    it do
      is_expected.to include(described_class.name)
      is_expected.to include(ton_upload.object_id.to_s)
      is_expected.to include(bucket_name)
      is_expected.to include(file_path)
    end
  end
end
