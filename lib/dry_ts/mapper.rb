module DryTs
  class Mapper
    def map_type(dry_type)
      case dry_type
      when Dry::Types::Constructor, Dry::Types::Constrained
        map(dry_type_value.type)
      when Dry::Types::Enum
        primitive = dry_type_value.type.primitive
        values = dry_type_value.values

        if primitive <= ApplicationEnumeration
          enum_name = primitive.to_s.gsub("Enums::", "")
          values = values.map { |x| "#{enum_name}.#{x.symbol.to_s.camelize}" }.join(" | ")

          [values, enum_name]
        elsif primitive == String
          values.map { |x| "'#{x}'" }.join(" | ")
        elsif primitive == Integer
          values.join(" | ")
        else
          raise "Cannot convert enum #{primitive} to TS type."
        end
      when Dry::Types::Array
        "Array<#{dry_type_to_ts_type(contract_klass, attribute, dry_type_value.member)}>"
      when Dry::Types::Hash
        "Record<string, any>"
      when Dry::Types::Nominal
        case dry_type_value.primitive.to_s
        when "Integer"
          "number"
        when "String", "Time", "Date"
          "string"
        when "TrueClass", "FalseClass"
          "boolean"
        else
          "unknown"
        end
      else
        "unknown"
      end
    end
  end
end
