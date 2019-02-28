# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

RSpec.shared_examples 'object property check' do |read, write|

  it 'has all the correct write properties' do
    write.each do |prop|
      expect(subject.respond_to?(prop)).to be true
      expect(subject.respond_to?("#{prop}=")).to be true
    end
  end

  it 'has all the correct read-only properties' do
    read.each do |prop|
      expect(subject.respond_to?(prop)).to be true
      expect(subject.respond_to?("#{prop}=")).not_to be true
    end
  end

end
