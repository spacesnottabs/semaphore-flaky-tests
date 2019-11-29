# frozen_string_literal: true

require_relative 'services/discover_flaky_pipelines'
require_relative 'services/failing_pipeline_tests'
require_relative 'serializers/flaky_test'

module SemaphoreRb
  class FlakyTests
    def initialize(semaphore_service, max_pages: 5)
      @semaphore_service = semaphore_service
      @max_pages = max_pages
    end

    def find_flaky_tests
      tests = {}

      foreach_flaky_test do |flaky_test|
        unique_key = "#{flaky_test.path}_#{flaky_test.line}"
        tests[unique_key] ||= { test: flaky_test, count: 0 }
        tests[unique_key][:count] += 1

        next if tests[unique_key][:test].branch == 'master'
        next unless flaky_test.branch == 'master'

        tests[unique_key][:test] = flaky_test
      end

      tests.values.each do |h|
        print Serializers::FlakyTest.new(h[:test]).to_s, "\t", h[:count], "\n\n"
      end
    end

    private

    attr_reader :semaphore_service, :max_pages

    def flaky_pipelines
      Services::DiscoverFlakyPipelines.new(
        semaphore_service,
        max_pages: max_pages
      ).call
    end

    def foreach_flaky_test(&block)
      flaky_pipelines.each do |pipeline|
        failing_pipeline_tests_service.list_failing_tests(pipeline).each(&block)
      end
    end

    def failing_pipeline_tests_service
      @failing_pipeline_tests_service ||=
        Services::FailingPipelineTests.new(semaphore_service)
    end
  end
end
