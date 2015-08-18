# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class LeadGenCard < TwitterAds::Creative::Card

      property :image_media_id
      property :cta
      property :fallback_url
      property :privacy_policy_url
      property :title
      property :submit_url
      property :submit_method
      property :custom_destination_url
      property :custom_destination_text
      property :custom_key_screen_name
      property :custom_key_name
      property :custom_key_email

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/cards/lead_gen' # @api private
      RESOURCE            = '/0/accounts/%{account_id}/cards/lead_gen/%{id}' # @api private

    end

  end
end
