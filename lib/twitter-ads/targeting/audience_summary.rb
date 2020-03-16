# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module AudienceSummary

    include TwitterAds::DSL
    include TwitterAds::Resource

    RESOURCE = "/#{TwitterAds::API_VERSION}/" \
                           'accounts/%{account_id}/audience_summary'

    property :audience_size, read_only: true

    class << self

      # Get an audience summary for the specified targeting criteria.
      #
      # @example
      #   TwitterAds::AudienceSummary.fetch(
      #     account,
      #     params: {targeting_criteria:[{targeting_type:'LOCATION',
      #             targeting_value:'96683cc9126741d1'}]}
      #   )
      #
      # @param params [Hash] A hash of input targeting criteria values
      #
      # @return [Hash] A hash containing the min and max audience size.
      #
      # @since 7.0.0
      # @see https://developer.twitter.com/en/docs/ads/campaign-management/api-reference/audience-summary
      def fetch(account, params)
        resource = RESOURCE % { account_id: account.id }
        headers = { 'Content-Type' => 'application/json' }

        response = TwitterAds::Request.new(account.client,
                                           :post,
                                           resource,
                                           headers: headers,
                                           body: params.to_json).perform
        response.body[:data]
      end

    end

  end
end
