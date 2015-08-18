# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class WebsiteCard < TwitterAds::Creative::Card

      property :image_media_id
      property :website_title
      property :website_url
      property :website_cta

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/cards/website' # @api private
      RESOURCE            = '/0/accounts/%{account_id}/cards/website/%{id}' # @api private

    end

  end
end
