# frozen_string_literal: true

module DryTs
  class Hello
    def self.greet
      "hello"
    end
  end

  class Analyzer
    def find_classes_in_module(mod)
      classes = []
      mod.constants.each do |const_name|
        const_value = mod.const_get(const_name)
        if const_value.is_a?(Class)
          classes << const_value
        elsif const_value.is_a?(Module)
          classes.concat(find_classes_in_module(const_value))
        end
      end
      classes
    end

    def generate_contract(contract_klass, schema)
      class_name = normalize_class_name(contract_klass)
      camelize_class_name = class_name.camelize
      file_path = Rails.root.join("generated", "contracts", "#{camelize_class_name}.ts")
      file_path.dirname.mkpath

      imports = []

      definitions = schema.types.map do |(attribute, value)|
        attribute_name = attribute.to_s.camelize(:lower)
        attribute_value, dependencies = dry_type_to_ts_type(contract_klass, attribute, value)

        imports << dependencies if dependencies

        [attribute_name, attribute_value]
      end

      File.write(file_path, <<~TS
        // GENERATED FILE. DO NOT EDIT.
        #{imports.map { |dependency| "import { #{dependency} } from '../enums/#{dependency}';" }.join("\n")}

        export interface #{camelize_class_name}Contract {
        #{definitions.map { |(attribute, value)| "\t#{attribute}: #{value}" }.join(",\n")}
        }
      TS
      )
    end

    def export_contracts
      FileUtils.rm_rf(Rails.root.glob("generated/contracts/**/*.ts"), verbose: VERBOSE)
      puts("Exporting contracts...")
      contracts_generated = 0

      descendants = find_classes_in_module(Contracts)
      descendants.each do |contract|
        schema = contract.schema
        if schema
          contracts_generated += 1
          generate_contract(contract, schema)
        else
          puts "Empty schema for #{contract}"
        end
      end

      puts("Exported #{contracts_generated} contracts.")
    end

    def self.[]
      puts "Hello from Analyzer"
    end
  end
end
