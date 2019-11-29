# frozen_string_literal: true

require_relative '../value_objects/pipeline_list'
require_relative 'pipeline'

module SemaphoreRb
  module Deserializers
    class PipelineList
      def initialize(parsed_json:, page_number:)
        @parsed_json = parsed_json
        @page_number = page_number
      end

      def deserialize
        ValueObjects::PipelineList.new(page: page_number, pipelines: pipelines)
      end

      private

      attr_reader :parsed_json, :page_number

      def pipelines
        parsed_json.map do |parsed_entry|
          Deserializers::Pipeline.new(parsed_entry).deserialize
        end
      end
    end
  end
end
