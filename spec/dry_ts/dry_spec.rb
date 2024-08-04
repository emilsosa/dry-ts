# frozen_string_literal: true

require "dry-types"

module Types
  include Dry.Types()
end

RSpec.describe DryTs::Mappers::Dry do
  context "when mapping a string" do
    let!(:result) { described_class.new.map(Types::Integer) }

    it "maps to a 'number'" do
      expect(result).to eq("number")
    end
  end
end
