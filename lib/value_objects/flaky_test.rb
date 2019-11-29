# frozen_string_literal: true

require 'pathname'

module SemaphoreRb
  module ValueObjects
    class FlakyTest
      attr_reader :failure, :pipeline, :job_id

      def initialize(failure:, pipeline:, job_id:)
        @failure = failure
        @pipeline = pipeline
        @job_id = job_id
      end

      def line
        failure.line
      end

      def path
        failure.path
      end

      def git_sha
        pipeline.git_sha
      end

      def pipeline_id
        pipeline.id
      end

      def branch
        pipeline.branch
      end

      def created_at
        pipeline.created_at
      end

      def github_link
        root = Pathname.new "#{ENV['GITHUB_PROJECT_URL']}/blob/#{git_sha}"
        relative = Pathname.new "#{path}#L#{line}"

        (root + relative).to_s
      end

      def semaphore_job_link
        "https://#{ENV['COMPANY']}.semaphoreci.com/jobs/#{job_id}"
      end
    end
  end
end
