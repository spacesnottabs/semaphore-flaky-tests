# frozen_string_literal: true

require 'curb'
require_relative 'base'

module SemaphoreRb
  module Adapters
    module Requesters
      class Curl < Base
        def initialize(api_key:)
          @api_key = api_key
        end

        def get(url)
          curler = ::Curl::Easy.new(url) do |curl|
            curl.headers['Authorization'] = "Token #{api_key}"
            curl.verbose = false
          end

          curler.perform

          if curler.response_code == 500
            sleep 2
            return get(url)
          end

          curler.body_str
        end

        private

        attr_reader :api_key
      end
    end
  end
end
