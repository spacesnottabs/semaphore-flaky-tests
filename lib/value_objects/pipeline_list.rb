# frozen_string_literal: true

module SemaphoreRb
  module ValueObjects
    class PipelineList
      attr_reader :pipelines, :page

      def initialize(pipelines:, page:)
        @pipelines = pipelines
        @page = page
      end
    end
  end
end
