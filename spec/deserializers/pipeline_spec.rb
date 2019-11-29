# frozen_string_literal: true

require 'time'
require_relative '../../lib/deserializers/pipeline'

describe SemaphoreRb::Deserializers::Pipeline do
  subject { described_class.new(parsed_json).deserialize }

  let(:parsed_json) do
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
  end

  it 'returns a ValueObjects::Pipeline object' do
    expect(subject).to be_a SemaphoreRb::ValueObjects::Pipeline
  end

  it 'returns an object with the correct parameters' do
    response = subject

    expect(response.id).to          eq 'pipeline_id'
    expect(response.workflow_id).to eq 'workflow_id'
    expect(response.result).to      eq 'PASSED'
    expect(response.git_sha).to     eq 'abcdef123'
    expect(response.branch).to      eq 'master'
    expect(response.created_at).to  eq 1574899200
  end
end
