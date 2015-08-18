# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class ImageAppDownloadCard < TwitterAds::Creative::Card

      property :app_country_code
      property :iphone_app_id
      property :iphone_deep_link
      property :ipad_app_id
      property :ipad_deep_link
      property :googleplay_app_id
      property :googleplay_deep_link
      property :app_cta
      property :wide_app_image_media_id

      RESOURCE_COLLECTION = '/0/accounts/%{account_id}/cards/image_app_download' # @api private
      RESOURCE            = '/0/accounts/%{account_id}/cards/image_app_download/%{id}' # @api private

    end

  end
end
