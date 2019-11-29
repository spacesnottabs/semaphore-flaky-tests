# frozen_string_literal: true

require_relative '../value_objects/pipeline'

module SemaphoreRb
  module Deserializers
    class Pipeline
      def initialize(parsed_json)
        @parsed_json = parsed_json
      end

      def deserialize
        ValueObjects::Pipeline.new(
          id: id,
          workflow_id: workflow_id,
          result: result,
          git_sha: git_sha,
          branch: branch,
          created_at: created_at
        )
      end

      private

      attr_reader :parsed_json

      def id
        parsed_json[:ppl_id]
      end

      def workflow_id
        parsed_json[:wf_id]
      end

      def result
        parsed_json[:result]
      end

      def git_sha
        parsed_json[:commit_sha]
      end

      def branch
        parsed_json[:branch_name]
      end

      def created_at
        parsed_json[:created_at][:seconds]
      end
    end
  end
end
