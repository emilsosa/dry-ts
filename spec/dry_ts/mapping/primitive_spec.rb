# frozen_string_literal: true

RSpec.describe DryTs::Mappers::Primitive do

  Numeric.subclasses.each do |subclass|
    context "when mapping a '#{subclass}'" do
      let!(:result) { sut.map(subclass) }

      it "maps to a 'number'" do
        expect(result).to eq("number")
      end
    end
  end

  [String, Time, Date].each do |subclass|
    context "when mapping a '#{subclass}'" do
      let!(:result) { sut.map(subclass) }

      it "maps to a 'string'" do
        expect(result).to eq("string")
      end
    end
  end

  [TrueClass, FalseClass].each do |subclass|
    context "when mapping a '#{subclass}'" do
      let!(:result) { sut.map(subclass) }

      it "maps to a 'boolean'" do
        expect(result).to eq("boolean")
      end
    end
  end

  context "when mapping an unknown type" do
    let!(:klass) do
      Class.new do
        def self.name
          "Unknown Class"
        end
      end
    end

    let!(:result) { sut.map(klass) }

    it "maps to an 'unknown'" do
      expect(result).to eq("unknown")
    end
  end
end
