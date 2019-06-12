# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

module TwitterAds
  module Batch

    CLASS_ID_MAP = {
      'TwitterAds::LineItem'                => 'LINE_ITEM',
      'TwitterAds::Campaign'                => 'CAMPAIGN',
      'TwitterAds::TargetingCriteria'       => 'TARGETING_CRITERION'
    }.freeze # @api private

    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods

      # Makes batch request(s) for a passed in list of objects
      #
      # @param account [Account] The Account object instance.
      # @param objs [Array] A collection of entities to save.
      #
      # @since 1.1.0
      def batch_save(account, objs)
        resource = self::RESOURCE_BATCH % { account_id: account.id }

        json_body = []

        objs.each do |obj|
          entity_type = CLASS_ID_MAP[obj.class.name].downcase
          obj_params = obj.to_params
          obj_json = { 'params' => obj_params }

          if obj.id.nil?
            obj_json['operation_type'] = 'Create'
          elsif obj.to_delete == true
            obj_json['operation_type'] = 'Delete'
            obj_json['params'][entity_type + '_id'] = obj.id
          else
            obj_json['operation_type'] = 'Update'
            obj_json['params'][entity_type + '_id'] = obj.id
          end

          json_body.push(obj_json)

        end

        headers = { 'Content-Type' => 'application/json' }
        response = TwitterAds::Request.new(account.client,
                                           :post,
                                           resource,
                                           headers: headers,
                                           body: json_body.to_json).perform

        # persist each entity
        objs.zip(response.body[:data]) { |obj, res_obj|
          obj.from_response(res_obj)
        }
      end

    end

  end
end
