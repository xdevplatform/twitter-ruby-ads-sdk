# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class UserSettings

    include TwitterAds::DSL
    include TwitterAds::Resource
    include TwitterAds::Persistence

    attr_reader :account

    property :notification_email
    property :contact_phone
    property :contact_phone_extension
    property :subscribed_email_types
    property :user_id

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
