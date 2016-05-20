# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class TVGenre

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :id, read_only: true
    property :name, read_only: true

    RESOURCE_COLLECTION = '/1/targeting_criteria/tv_genres'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
