# frozen_string_literal: true

require_relative 'base'

module SemaphoreRb
  module Adapters
    module Requesters
      class Fake < Base
        def initialize(stubs: {})
          @stubs = stubs
        end

        def get(url)
          stubs[url].to_s
        end

        private

        attr_reader :stubs
      end
    end
  end
end
