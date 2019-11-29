# frozen_string_literal: true

require_relative '../parsers/rspec_log'

module SemaphoreRb
  module Services
    class LogsAnalyzer
      PARSERS = [
        Parsers::RspecLog
      ].freeze

      def self.analyze(log_data, parsers: PARSERS)
        new(log_data, parsers: parsers).analyze
      end

      def initialize(log_data, parsers: PARSERS)
        @log_data = log_data
        @parsers = parsers
      end

      def analyze
        parsers.map(&method(:parse_log_data)).flatten
      end

      private

      attr_reader :log_data, :parsers

      def parse_log_data(parser)
        parser.parse(log_data)
      end
    end
  end
end
