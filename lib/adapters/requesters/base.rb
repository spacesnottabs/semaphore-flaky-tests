# frozen_string_literal: true

require 'json'

module SemaphoreRb
  module Adapters
    module Requesters
      class Base
        def get_parsed(url)
          JSON.parse(get(url), symbolize_names: true)
        end

        def get(_url)
          raise NotImplementedError
        end
      end
    end
  end
end
