# frozen_string_literal: true

require_relative '../deserializers/pipeline_list'

module SemaphoreRb
  module Services
    class Semaphore
      def initialize(company:, project_id:, requester:)
        @company = company
        @project_id = project_id
        @requester = requester
      end

      def list_pipelines(page)
        url = "#{root_url}/pipelines?project_id=#{project_id}&page=#{page}"

        parsed = requester.get_parsed url

        Deserializers::PipelineList.new(
          parsed_json: parsed,
          page_number: page
        ).deserialize
      end

      def list_pipeline_failing_job_ids(pipeline_id)
        url = "#{root_url}/pipelines/#{pipeline_id}?detailed=true"

        parsed = requester.get_parsed url

        parsed[:blocks].map do |block|
          block[:jobs].select { |job| job[:result] == 'FAILED' }
                      .map { |job| job[:job_id] }
        end.flatten.compact
      end

      def get_job_log(job_id)
        `sem logs #{job_id}`
      end

      private

      attr_reader :company, :project_id, :requester

      def root_url
        "https://#{company}.semaphoreci.com/api/v1alpha"
      end
    end
  end
end
