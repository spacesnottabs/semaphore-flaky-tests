# frozen_string_literal: true

module SemaphoreRb
  module ValueObjects
    class Pipeline
      attr_reader :id, :workflow_id, :result, :git_sha, :branch, :created_at

      def initialize(id:, workflow_id:, result:, git_sha:, branch:, created_at:)
        @id = id
        @workflow_id = workflow_id
        @result = result
        @git_sha = git_sha
        @branch = branch
        @created_at = created_at
      end
    end
  end
end
