# frozen_string_literal: true

require "date"
require "bigdecimal"

module DryTs
  module Mappers
    class Primitive
      def map(primitive)
        if primitive <= Numeric
          "number"
        elsif primitive <= String || primitive <= Time || primitive <= Date
          "string"
        elsif primitive <= TrueClass || primitive <= FalseClass
          "boolean"
        else
          "unknown"
        end
      end
    end
  end
end
