# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterRestApi
  class UserIdLookup
    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :id_str, read_only: true
    property :screen_name, read_only: true

    DOMAIN = 'https://api.twitter.com'
    RESOURCE = '/1.1/users/show.json'

    def self.load(account, opts = {})
      response = TwitterAds::Request.new(
        account.client,
        :get,
        RESOURCE,
        params: opts,
        domain: DOMAIN
      ).perform
      new.from_response(response.body, response.headers)
    end
  end
end
