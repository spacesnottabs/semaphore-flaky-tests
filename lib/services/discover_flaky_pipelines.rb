# frozen_string_literal: true

require 'ostruct'

module SemaphoreRb
  module Services
    class DiscoverFlakyPipelines
      def initialize(semaphore_service, max_pages: 5)
        @semaphore_service = semaphore_service
        @max_pages = max_pages
      end

      def call
        group_pipelines_by_git_sha.select do |pipelines|
          results = pipelines.map(&:result)
          next unless results.include? 'PASSED'
          !(results & %w[FAILED STOPPED]).empty?
        end.flatten
      end

      private

      attr_reader :max_pages, :semaphore_service

      def group_pipelines_by_git_sha
        pipelines_by_commit = {}

        list_pipelines.each do |pipeline|
          pipelines_by_commit[pipeline.git_sha] ||= []
          pipelines_by_commit[pipeline.git_sha] << pipeline
        end

        pipelines_by_commit.values
      end

      def list_pipelines
        (1..max_pages).map do |page|
          semaphore_service.list_pipelines(page).pipelines
        end.flatten
      end
    end
  end
end
