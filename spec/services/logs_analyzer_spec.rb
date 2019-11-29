# frozen_string_literal: true

require 'time'
require_relative '../../lib/services/logs_analyzer'

describe SemaphoreRb::Services::LogsAnalyzer do
  subject { described_class.analyze(rspec_log) }

  let(:rspec_log) do
    <<~RSPEC_LOG
Finished in 1 minute 41.63 seconds (files took 5.42 seconds to load)
1019 examples, 2 failures, 1 pending

Failed examples:

rspec ./spec/path/to/error1.rb:110 # Path::To::Error1
rspec ./spec/path/to/error2.rb:48 # Path::To::Error2

Randomized with seed 56924

exit code: 1 duration: 110s
RSPEC_LOG
  end

  it 'returns a ValueObjects::TestFailure array' do
    expect(subject).to be_a Array
    expect(subject[0]).to be_a SemaphoreRb::ValueObjects::TestFailure
    expect(subject[1]).to be_a SemaphoreRb::ValueObjects::TestFailure
  end

  it 'return correct paths' do
    expect(subject[0].path).to eq './spec/path/to/error1.rb'
    expect(subject[1].path).to eq './spec/path/to/error2.rb'
  end

  it 'return correct lines' do
    expect(subject[0].line).to eq '110'
    expect(subject[1].line).to eq '48'
  end
end
