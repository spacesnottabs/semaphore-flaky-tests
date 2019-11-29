# frozen_string_literal: true

module SemaphoreRb
  module ValueObjects
    class TestFailure
      attr_reader :path, :line

      def initialize(path:, line:)
        @path = path
        @line = line
      end
    end
  end
end
