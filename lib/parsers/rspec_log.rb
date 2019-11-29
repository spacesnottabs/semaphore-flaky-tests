# frozen_string_literal: true

require_relative '../value_objects/test_failure'

module SemaphoreRb
  module Parsers
    class RspecLog
      def self.parse(log_data)
        new(log_data).parse
      end

      def initialize(log_data)
        @log_data = log_data
      end

      def parse
        match = /Failed examples:(?<failures>.+)Random/m.match(log_data)
        return [] unless match

        match[:failures].split("\n").map do |line|
          match = /rspec (?<path>\S+):(?<line>\d+)/.match line

          next unless match

          ValueObjects::TestFailure.new(path: match[:path], line: match[:line])
        end.compact
      end

      private

      attr_reader :log_data
    end
  end
end
