# frozen_string_literal: true

require 'time'
require_relative '../../lib/deserializers/pipeline_list'

describe SemaphoreRb::Deserializers::PipelineList do
  subject do
    described_class.new(
      page_number: 5,
      parsed_json: parsed_json
    ).deserialize
  end

  let(:parsed_json) do
    [
      {
        ppl_id: 'pipeline_id',
        wf_id: 'workflow_id',
        result: 'PASSED',
        commit_sha: 'abcdef123',
        branch_name: 'master',
        created_at: {
          seconds: Time.parse('2019-11-28').to_i
        }
      }
    ]
  end

  it 'returns a ValueObjects::PipelineList object' do
    expect(subject).to be_a SemaphoreRb::ValueObjects::PipelineList
  end

  it 'returns correct parameters' do
    response = subject

    expect(response.page).to eq 5
    expect(response.pipelines.length).to eq 1
    expect(response.pipelines.first).to be_a SemaphoreRb::ValueObjects::Pipeline
  end

  it 'returns pipelines with the correct parameters' do
    response = subject.pipelines.first

    expect(response.id).to          eq 'pipeline_id'
    expect(response.workflow_id).to eq 'workflow_id'
    expect(response.result).to      eq 'PASSED'
    expect(response.git_sha).to     eq 'abcdef123'
    expect(response.branch).to      eq 'master'
    expect(response.created_at).to  eq 1574899200
  end
end
