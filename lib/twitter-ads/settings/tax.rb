# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class TaxSettings

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence

    attr_reader :account

    property :address_city
    property :address_country
    property :address_email
    property :address_first_name
    property :address_last_name
    property :address_name
    property :address_postal_code
    property :address_region
    property :address_street1
    property :address_street2
    property :bill_to
    property :business_relationship
    property :client_address_city
    property :client_address_country
    property :client_address_email
    property :client_address_first_name
    property :client_address_last_name
    property :client_address_name
    property :client_address_postal_code
    property :client_address_region
    property :client_address_street1
    property :client_address_street2
    property :invoice_jurisdiction
    property :tax_category
    property :tax_exemption_id
    property :tax_id

    # sdk only
    property :to_delete, type: :bool

    RESOURCE = "/#{TwitterAds::API_VERSION}/" +
               'accounts/%{account_id}/user_settings/%{id}'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end

  end
end
