# Copyright (C) 2015 Twitter, Inc.

# Helper module for custom test matchers and utilities.
module Helpers

  # A utility method to temporarily redirect stdout and stderr for
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

  # Utility method for returning a JSON fixture file.
  #
  # @param name [Symbol] The name of the fixture file to be returned.
  #
  # @return [File] The file instance of the fixture specified.
  def fixture(name)
    File.new(File.expand_path("../../fixtures/#{name}.json", __FILE__))
  end

  def stub_fixture(method, name, url)
    stub_request(method, url).to_return(body: fixture(name), status: 200)
  end

end
