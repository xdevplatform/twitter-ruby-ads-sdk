# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

# Helper module for custom test matchers and utilities.
module Helpers

  # Helper method to temporarily redirect stdout and stderr for
  # a given block of code.
  #
  # @param &block [Block] The code block to be executed.
  #
  # @return [Object] The result of the block.
  def silence(&block)
    original_stdout = $stdout
    original_stderr = $stderr
    $stdout = $stderr = File.new('/dev/null', 'w')
    yield block
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  # Helper method for returning a JSON fixture file.
  #
  # @param name [Symbol] The name of the fixture file to be returned.
  #
  # @return [File] The file instance of the fixture specified.
  def fixture(name)
    File.new(File.expand_path("../../fixtures/#{name}.json", __FILE__))
  end

  # Helper method to stub a request with a fixture by name.
  #
  # @param method [Symbol] The HTTP method (:get, :put, :post, :delete)
  # @param name [String] The fixture name.
  # @param url [String] The URL match pattern or regular expression.
  # @param status [Integer] The response code to return with the fixture.
  def stub_fixture(method, name, url, status: 200, headers: {})
    stub_request(method, url).to_return(body: fixture(name), status: status, headers: headers)
  end

end
