# frozen_string_literal: true

require 'time'
require_relative '../../lib/services/discover_flaky_pipelines'

describe SemaphoreRb::Services::DiscoverFlakyPipelines do
  subject { described_class.new(semaphore_service, max_pages: 1).call }

  let(:flaky_pipeline_passed) do
    SemaphoreRb::ValueObjects::Pipeline.new(
      id:          'pipeline_id',
      workflow_id: 'workflow_id',
      result:      'PASSED',
      git_sha:     'abcdef123',
      branch:      'master',
      created_at:  1574899200
    )
  end

  let(:flaky_pipeline_failed) do
    SemaphoreRb::ValueObjects::Pipeline.new(
      id:          'pipeline_id2',
      workflow_id: 'workflow_id2',
      result:      'FAILED',
      git_sha:     'abcdef123',
      branch:      'master',
      created_at:  1574899222
    )
  end

  let(:consistent_pipeline_passed1) do
    SemaphoreRb::ValueObjects::Pipeline.new(
      id:          'pipeline_id3',
      workflow_id: 'workflow_id3',
      result:      'PASSED',
      git_sha:     'abcdef124',
      branch:      'master',
      created_at:  1574899222
    )
  end

  let(:consistent_pipeline_passed2) do
    SemaphoreRb::ValueObjects::Pipeline.new(
      id:          'pipeline_id4',
      workflow_id: 'workflow_id4',
      result:      'PASSED',
      git_sha:     'abcdef124',
      branch:      'master',
      created_at:  1574899222
    )
  end

  let(:consistent_pipeline_failed) do
    SemaphoreRb::ValueObjects::Pipeline.new(
      id:          'pipeline_id5',
      workflow_id: 'workflow_id5',
      result:      'FAILED',
      git_sha:     'abcdef125',
      branch:      'master',
      created_at:  1574899222
    )
  end

  let(:semaphore_service) { double 'semaphore' }

  before do
    expect(semaphore_service).to receive(:list_pipelines).with(1).and_return(
      SemaphoreRb::ValueObjects::PipelineList.new(
        page: 1,
        pipelines: [
          flaky_pipeline_passed,
          flaky_pipeline_failed,
          consistent_pipeline_passed1,
          consistent_pipeline_passed2,
          consistent_pipeline_failed
        ]
      )
    )
  end

  it 'returns list of flaky pipelines' do
    expect(subject).to match a_collection_containing_exactly(
      flaky_pipeline_passed,
      flaky_pipeline_failed
    )
  end
end
