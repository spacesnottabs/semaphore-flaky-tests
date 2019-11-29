# frozen_string_literal: true

require 'json'

module SemaphoreRb
  module Serializers
    class FlakyTest
      def initialize(flaky_test)
        @flaky_test = flaky_test
      end

      def to_s
        JSON.pretty_generate(to_h)
      end

      def to_h
        { path: flaky_test.path,
          line: flaky_test.line,
          git_sha: flaky_test.git_sha,
          pipeline_id: flaky_test.pipeline_id,
          job_id: flaky_test.job_id,
          branch: flaky_test.branch,
          github_link: flaky_test.github_link,
          semaphore_job_link: flaky_test.semaphore_job_link,
          created_at: Time.at(flaky_test.created_at).to_s }
      end

      private

      attr_reader :flaky_test
    end
  end
end
