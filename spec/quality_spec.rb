# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

require 'spec_helper'

describe 'Code Style & Quality', :quality do

  # If this test fails, you need to run 'rubocop' to see what needs to be fixed.
  # Please see the CONTRIBUTING.md file for additional style guide information.
  it 'has no style guide or quality violations', :style do
    result = RuboCop::CLI.new.run([])
    expect(result).to eq(0)
  end unless RUBY_ENGINE =~ /rbx/

end
