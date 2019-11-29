# frozen_string_literal: true

require_relative '../value_objects/flaky_test'
require_relative 'logs_analyzer'

module SemaphoreRb
  module Services
    class FailingPipelineTests
      def initialize(semaphore_service)
        @semaphore_service = semaphore_service
      end

      def list_failing_tests(pipeline)
        job_ids = semaphore_service.list_pipeline_failing_job_ids(pipeline.id)

        job_ids.map do |job_id|
          log_data = semaphore_service.get_job_log(job_id)

          failures = LogsAnalyzer.new(log_data).analyze

          failures.map do |failure|
            ValueObjects::FlakyTest.new(
              failure: failure,
              job_id: job_id,
              pipeline: pipeline
            )
          end
        end.flatten.compact
      end

      private

      attr_reader :semaphore_service
    end
  end
end
