# frozen_string_literal: true

require "dry/types"

module DryTs
  module Mappers
    class Dry
      attr_reader :primitive_mapper

      def initialize
        @primitive_mapper = Primitive.new
      end

      def map(dry_type)
        case dry_type
        when Dry::Types::Constructor, Dry::Types::Constrained
          map(dry_type.type)
        when Dry::Types::Enum
          primitive = dry_type_value.type.primitive
          values = dry_type_value.values

          raise NotImplementedError
          # if primitive == String
          #   values.map { |x| "'#{x}'" }.join(" | ")
          # elsif primitive == Integer
          #   values.join(" | ")
          # else
          #   raise "Cannot convert enum #{primitive} to TS type."
          # end
        when Dry::Types::Array
          "Array<#{map(dry_type.member)}>"
        when Dry::Types::Hash
          "Record<string, any>"
        when Dry::Types::Nominal
          @primitive_mapper.map(dry_type.primitive)
        else
          "unknown"
        end
      end
    end
  end
end
